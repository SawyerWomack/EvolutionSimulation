# Evolution Simulation
This project was inspired by Sebastian Lague's video on simulating an ecosystem. It of course is not as pretty
but you are able to create massive simulations that are very stable. The parameters on the title screen are
self explanatory as well as the graphs on the side. If you want a further explaination, the simulation will be described in detail in this document as well as examples
of simulation parameters and what results from those parameters.

# Interpeting the simulation

When you run the simulation you will see three differrent nodes:

### Prey

![pre](https://user-images.githubusercontent.com/58866083/209586966-84a62418-5f87-4807-8630-81653fc2edcf.png)

Prey wander around the map until they spot food. When they do they move torward that food until they eat it. When they it the food they destroy it and make
another prey that has similar but slightly altered traits.

### Predators

![Pred](https://user-images.githubusercontent.com/58866083/209587025-1b78c1cf-3fdf-41e5-9ef4-51333964c274.png)

Predators wander around the map just like prey. However when a predator spots a prey it will hunt it down and attempt to eat it. If the predator does eat the prey then 
it will kill the prey removing it from the map, replinishing the predator's hunger, and producing another predator with similar but slightly altered traits.

### Food

![Food](https://user-images.githubusercontent.com/58866083/209587040-8c9a5951-ceb2-40f8-a22e-de28f1b29c92.png)

Food is spawned at random around the map and has no function aside from being eaten by prey. Food is spawned the beginning of day and night.

Another thing you may notice when you run the simulation is that the map get dark and bright at intervals. This is the day night cycle at work. The length of the day night cycle can be influenced by the 
**Day/Night** variable when you first launch the simulation. The day night cycle also contributes 
to a trait that prey and predators have called **Sight**. The sight trait is a value betweeen 1 and 10 that determines the radius that the node can see during the day and during the night.
How it works is if the value is 8 for example, it can see 8 tiles out during the day. At night however it can only see 2 tiles out. Another traits that both prey and predators have is **speed**.
The speed trait is a value between 1 and 10 that influences how fast the node moves and how long the node needs to rest in between moves. It also influences the hunger cost to move. For example if a nodes speed
is 8 it can move every 2 seconds but it costs 8 hunger to move.





