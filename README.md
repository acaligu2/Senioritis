# Senioritis

iOS game developed in Xcode using Swift

Graduation is in sight! Dodge your professors and their busy work and hope you make it to commencement

The goal is to avoid any professors/work, each passing professor represents a day in the spring semester.

There are four possibilities for enemy movement:

  1.) Running at the player
  2.) Running and jumping
  3.) Running and shooting projectiles
  4.) Running, jumping and shooting projectiles
  
The movement for the enemies is randomly selected from an array of SKAction sequences. All collision
detection was done using SKPhysicBodies. If the player is hit by either a projectile or a professor,
An 'X' is displayed at the top of the screen. Once three Xs are detected, the game is over.

If the player makes it to May 10th, they win and the game is over.

I did all the artwork myself using pixilart.com
