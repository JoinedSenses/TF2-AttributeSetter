# TF2-AttributeSetter  
Modify attributes of client weapons on the fly  
This plugin was created for development and testing  

Requires smlib and tf2attributes

## Commands:  
sm_attribute (target) // Change attributes of targetted client's active weapon
sm_resetattributes (target|blank) // Reset attributes on all weapons of target. If blank, resets attributes of self.
sm_getweapon (target) // Displays client active weapon name and entity#

How:  
/attribute playerName intAttribute floatValue
/resetattributes playerName
/getweapon playerName

List of attributes:  
https://wiki.teamfortress.com/wiki/List_of_item_attributes
