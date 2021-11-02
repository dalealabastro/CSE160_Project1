#include <Timer.h>
#include "includes/command.h"
#include "includes/packet.h"
#include "includes/CommandMsg.h"
#include "includes/sendInfo.h"
#include "includes/channels.h"

module Node{
    uses interface Boot;

    uses interface SplitControl as AMControl;
    uses interface Receive;

    uses interface SimpleSend as Sender;

    uses interface CommandHandler;

    uses interface NeighborDiscovery;

    uses interface Flooding;

    //output of flooding
    uses interface SimpleSend as FloodSender;
    //routing table
    uses interface SimpleSend as RouteSender;
    uses interface Hashmap<route> as routingTable;

    uses interface LinkState;

    uses interface TCPHandler;
}

implementation{
    pack sendPackage;

    // Prototypes
    void makePack(pack *Package, uint16_t src, uint16_t dest, uint16_t TTL, uint16_t Protocol, uint16_t seq, uint8_t *payload, uint8_t length);

    event void Boot.booted() {
        
        call AMControl.start();

        call NeighborDiscovery.start();

        call LinkState.start();
    }

    event void AMControl.startDone(error_t err) {
        if(err == SUCCESS) {
            dbg(GENERAL_CHANNEL, "Radio On\n");
        } else {
            //Retry until successful
            call AMControl.start();
        }
    }

    event void AMControl.stopDone(error_t err) {
        switch(msg->protocol) 
        {
            case PROTOCOL_PING:
                dbg(GENERAL_CHANNEL, "--- Ping recieved from %d\n", msg->src);
                dbg(GENERAL_CHANNEL, "--- Packet Payload: %s\n", msg->payload);
                dbg(GENERAL_CHANNEL, "--- Sending Reply...\n");
                makePack(&sendPackage, msg->dest, msg->src, MAX_TTL, PROTOCOL_PINGREPLY, current_seq++, (uint8_t*)msg->payload, PACKET_MAX_PAYLOAD_SIZE);
                call RoutingHandler.send(&sendPackage);
                break;
                    
            case PROTOCOL_PINGREPLY:
                dbg(GENERAL_CHANNEL, "--- Ping reply recieved from %d\n", msg->src);
                break;
                    
            default:
                dbg(GENERAL_CHANNEL, "Unrecognized ping protocol: %d\n", msg->protocol);
        }
    }

    event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len) {
        if (len == sizeof(pack)) {
            pack* myMsg=(pack*) payload;

            // Check TTL
            if (myMsg->TTL-- == 0) {
                return msg;
            }

            // Distance Vector
            if (myMsg->protocol == PROTOCOL_DV) {
                call RoutingHandler.recieve(myMsg);
            
            // TCP
            } else if (myMsg->protocol == PROTOCOL_TCP && myMsg->dest == TOS_NODE_ID) {
                call TCPHandler.recieve(myMsg);

            // Regular Ping
            } else if (myMsg->dest == TOS_NODE_ID) {
                pingHandler(myMsg);
                
            // Neighbor Discovery
            } else if (myMsg->dest == AM_BROADCAST_ADDR) {
                call NeighborDiscoveryHandler.recieve(myMsg);

            // Not Destination
            } else {
                call RoutingHandler.send(myMsg);
            }
            return msg;
        }
        dbg(GENERAL_CHANNEL, "Unknown Packet Type %d\n", len);
        return msg;
    }


    event void CommandHandler.ping(uint16_t destination, uint8_t *payload){
        route routeDest;

        dbg(GENERAL_CHANNEL, "PING EVENT \n");
        if(call routingTable.contains(destination))
        {
            routeDest = call routingTable.get(destination); // ---

            
            makePack(&sendPackage, TOS_NODE_ID, destination, MAX_TTL, PROTOCOL_PING, 0, payload, PACKET_MAX_PAYLOAD_SIZE);

            dbg(NEIGHBOR_CHANNEL, "To get to:%d, send through:%d\n", destination, routeDest.nextHop);
            call RouteSender.send(sendPackage, routeDest.nextHop);
        }
        else{
          makePack(&sendPackage, TOS_NODE_ID, destination, 0, PROTOCOL_PING, 0, payload, PACKET_MAX_PAYLOAD_SIZE);
          dbg(NEIGHBOR_CHANNEL, "Coudn't find the Routing Table for:%d so flooding\n", TOS_NODE_ID);
          call FloodSender.send(sendPackage, destination);
        }
        //  makePack(&sendPackage, TOS_NODE_ID, destination, 0, 0, 0, payload, PACKET_MAX_PAYLOAD_SIZE);
        //  call FloodSender.send(sendPackage, destination);
    }

    event void CommandHandler.printNeighbors() {
        call NeighborDiscovery.print();
    }

    event void CommandHandler.printRouteTable() {
        call LinkState.printRoutingTable();
    }

    event void CommandHandler.printLinkState() {
        call LinkState.print();
    }

    event void CommandHandler.printDistanceVector() {}

    event void CommandHandler.setTestServer()
    {
        dbg(GENERAL_CHANNEL, "TEST_SERVER EVENT\n");
        call TCPHandler.startServer(port);
    }

    event void CommandHandler.setTestClient() 
    {
        dbg(GENERAL_CHANNEL, "TEST_CLIENT EVENT\n");
        call TCPHandler.startClient(dest, srcPort, destPort, transfer);
    }

    event void CommandHandler.setAppServer() {}

    event void CommandHandler.setAppClient() {}

    void makePack(pack *Package, uint16_t src, uint16_t dest, uint16_t TTL, uint16_t protocol, uint16_t seq, uint8_t* payload, uint8_t length) {
        Package->src = src;
        Package->dest = dest;
        Package->TTL = TTL;
        Package->seq = seq;
        Package->protocol = protocol;
        memcpy(Package->payload, payload, length);
    }
}
