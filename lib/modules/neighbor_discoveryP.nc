//File created (not original)

#include "../../includes/sendInfo.h"

generic module neighbor_discoveryP()
{
    provides interface neighbor_discovery;                    
}

implementation
{
    /*uint16_t* nodeNeighbors[size];                        //2D container? Does it work like this?
    command void linkedListGenerator()                       //linkedListGenerator is our own variable. Calls command.
    {
        uint16_t i;
        for (i = 0; i < size; i++)
        {   
            nodeNeighbors[i] = neighbor_discovery.neighborSearch(i + 1);          //should return array back
            
        }
    }
    command uint16_t* neighborSearch(uint16_t node)
    {
        //pseudoMoteIds                               //Pseudo till we figure out how to connect python to this 
        uint16_t neighbors[size - 1]                //assumingly worst case is size - 1
        uint8_t lineNumber = 0;                     //Custom variable
        //This is pseudo code
        //for(pseudoMoteIds)
        //      if pseudoMoteIds.source = node
        //          neighbors[lineNumber] = pseudoMoteIds.destination;
        //          lineNumber++;
        //return neighbors;
    }*/

    int current[19];
    int flood[19];
    int check[19];
    command void neighbor_discovery.NodeQueue() // Testing
    {
        int i;
        // Finds Neighbors
        for(i = 0; i < 19; i++)
        {
            flood[i] = i + 3;
            //dbg(GENERAL_CHANNEL, "Node Inserted%i\n", container[i]);
        }

        int j;
        for(j = 0; j < 19; j++)
        {
            if(current[j] == 0)
            {
                break;
            }

            check[current[j]] = current[j];
        }

        // Calls Flood

        int k;
        for(k = 0; k < 19; k++)
        {
            if(flood[k] == 0)
            {
                break;
            }

            current[k] = flood[k]
        }

        //dbg(GENERAL_CHANNEL, "Insertion Complete\n");
    }

    command void neighbor_discovery.TRIALFUCKTEST() // Works
    {
        dbg(GENERAL_CHANNEL, "THIS IS A FUCKING TEST TWAT\n");
    }
}









    //Create function that creates linked list (state variable that we can access)
    //Said function ^ also calls another function that will search for neighbors for each node and returns a list
    //Flood neighbor depending on which origin node we are currently at.
    //Call another function which will store neighbors that sent the message in another list to make sure no message is sent backwards up the pipeline.