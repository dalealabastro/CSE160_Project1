//File created (not original)

#include "../../includes/sendInfo.h"

module neighbor_discoveryP(uint16_t size)
    {
        provides interface neighbor_discovery;
        uses {
            interface Queue <uint16_t*>;                //cuz why not
            interface List;
            }                       
    }

implementation
    {
        uint16_t* nodeNeighbors[size];                        //2D container? Does it work like this?
        command void neighbor_discovery.linkedListGenerator()                       //linkedListGenerator is our own variable. Calls command.
        {
            for (uint16_t i = 0; i < size; i++)
            {   
                nodeNeighbors[i] = neighbor_discovery.neighborSearch(i + 1);          //should return array back
                
            }
        }
        command uint16_t* neighborSearch(uint16_t node)
        {
            pseudoMoteIds                               //Pseudo till we figure out how to connect python to this 
            uint16_t neighbors[size - 1]                //assumingly worst case is size - 1
            uint8_t lineNumber = 0;                     //Custom variable
            //This is pseudo code
            //for(pseudoMoteIds)
            //      if pseudoMoteIds.source = node
            //          neighbors[lineNumber] = pseudoMoteIds.destination;
            //          lineNumber++;
            //return neighbors;
        }
    }









    //Create function that creates linked list (state variable that we can access)
    //Said function ^ also calls another function that will search for neighbors for each node and returns a list
    //Flood neighbor depending on which origin node we are currently at.
    //Call another function which will store neighbors that sent the message in another list to make sure no message is sent backwards up the pipeline.