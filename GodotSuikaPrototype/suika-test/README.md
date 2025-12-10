# Cafe Suika

## Gameplay Description
A puzzle game where you match and merge ingredients to create coffee recipes before time runs out!

### How to Play

**Objective:** Complete coffee recipes by merging ingredients before the timer runs out.

# Controls:
- **Mouse** Move the cloud left and right to position ingredients
- **Left Click:** Drop an ingredient from the cloud into the jar
- **Space:** Restart after game over or continue after completing a recipe

# Game Mechanics:

1. **Merging Ingredients:** Ingredients fall into the jar with physics. When two identical ingredients from the same chain touch, they merge into the next level ingredient.

2. # Ingredient Chains:
   - **Milk Chain:** Milk → Steamed Milk → Creamer → Heavy Cream → Whipped Cream
   - **Coffee Chain:** Coffee Bean → Coffee → Espresso
   - **Sugar Chain:** Sugar → Caramel Syrup → Chocolate Syrup

3. # Recipes (Randomly Generated):
   - **Cappuccino:** 1 Espresso + 1 Steamed Milk
   - **Latte:** 1 Espresso + 1 Creamer + 1 Sugar
   - **Mocha:** 1 Coffee + 1 Creamer + 1 Chocolate Syrup

4. **The Trash:** Unwanted ingredients can be dragged/dropped to the left side trash area to remove them.

5. **Timer:** You have 60 seconds to complete each recipe. Complete it in time to get a new recipe and reset the timer. Run out of time and it's game over!

6. **Tutorial:** Cappy the barista will guide you through your first recipe at the start of the game.

## Screenshots

![Initial_setup_in_unity](CafeSuika/GodotSuikaPrototype/Screenshots/Screenshot 2025-12-10 094123.png)
![Switching_over_to_godot](CafeSuika/GodotSuikaPrototype/Screenshots/Screenshot 2025-12-10 092447.png)
![final_in_godot](CafeSuika/GodotSuikaPrototype/Screenshots/Screenshot 2025-12-10 094216.png)


## Reflection

### What I Learned

**Technical Skills:**
- How to use the Godot game engine and GDScript
- Implementing physics-based gameplay with RigidBody2D nodes
- Creating collision detection and merging mechanics

**Game Design:**
- Balancing difficulty with the timer system
- Creating clear visual feedback for player actions

**Problem-Solving:**
- Debugging collision detection issues with ingredients
- Making the cloud movement feel responsive, having it follow the mouse
- Implementing the recipe checking system
- Managing ingredient chains and merge logic

**What Went Well:**
- Visuals
- Merge mechanic
- Implementation of 'layers' of Suika where only certain ingredients can merge with other ingredients

**What I Would Improve:**
- More recipes for variety
- Better visual effects when merging
- More polished UI design
- Additional sound effects and music

**What I plan to add**
- 'Diner Dash' management sim section
- Powerups
- More recipes with more complexity
- More art, reactive sprites to game win/loss