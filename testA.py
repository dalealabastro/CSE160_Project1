from TestSim import TestSim

def main():
    # Get simulation ready to run.
    s = TestSim();

    # Before we do anything, lets simulate the network off.
    s.runTime(1);

    # Load the the layout of the network.
    s.loadTopo("long_line.topo");

    # Add a noise model to all of the motes.
    s.loadNoise("no_noise.txt");

    # Turn on all of the sensors.
    s.bootAll();

    # Add the main channels. These channels are declared in includes/channels.h
    s.addChannel(s.COMMAND_CHANNEL);
    s.addChannel(s.GENERAL_CHANNEL);
    s.addChannel(s.TRANSPORT_CHANNEL);
    #s.addChannel(s.ROUTING_CHANNEL);

    """
    Format: call the function first and then the runTime
    """

    s.runTime(500);
    s.setServer(1,1);
    s.runTime(500);
    s.setClient(2,"hello shrithik 3\n");
    s.runTime(500);
    s.setClient(3,"hello dale 3\n");
    s.runTime(500);
    s.setClient(7,"hello hamid 3\n");
    s.runTime(500);
    s.setClient(2,"msg hello World!\n");
    s.runTime(500);
    s.setClient(7,"whisper dale hi!\n");
    s.runTime(500);
    s.setClient(2,"listusr\n");
    s.runTime(500);
    """
    s.testServer(8, 7);
    s.runTime(50);
    #s.testServer(6, 3);
    #s.runTime(50);
    #s.runTime(500);
    #source, dest, srcPort, destPort, data
    s.testClient(9, 8, 4, 7, 250); #char value limit of 255 on transfer...
    s.runTime(800);
    s.testClient(10, 8, 5, 7, 250);
    s.runTime(800);
    #src, dest, destPort, srcPort
    #s.testClientClose(9, 8, 7, 4);
    #s.runTime(200);
    #s.runTime(60);
    #s.testClientClose(10, 6, 3, 5);
    #s.runTime(280);
    """
if __name__ == '__main__':
    main(
