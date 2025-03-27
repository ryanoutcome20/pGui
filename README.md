# pGui

## Overview

pGui is a lightweight, modular GUI framework for Garry's Mod, written entirely in Lua. It provides customizable UI elements to integrate into your menu designs. Features include:
  * Dynamically resizable menu frames.
  * Automatic layout management for elements.
  * Easily integrated into existing projects.
  * Modular architecture for custom UI components.
  * Built-in elements such as checkboxes, dropdowns, lists, and more.
  * Intuitive configuration for easy customization.
  * Clean and minimalistic design for an aesthetically pleasing UI.

<details>
  <summary>Images and Screenshots</summary>
  
  ![Framework Image #1](https://i.imgur.com/J51umuG.png)
  ![Framework Image #2](https://i.imgur.com/rf5vvaf.png)
  ![Framework Image #3](https://i.imgur.com/NAkpLWi.png)
  ![Framework Image #4](https://i.imgur.com/SC4OOpA.png)
</details>

## Installation

You can install pGui via the [releases](https://github.com/ryanoutcome20/pGui/releases/) or manually by following these steps:

1. Cloning the repository:
   ```bash
   git clone https://github.com/ryanoutcome20/pgui.git
   ```
2. Including in your project:
  ```lua
  include( 'pGui/menu.lua' )
  ```

## Usage / Form

Once included in your project, you can start building your menu by defining menu elements within the `form` file or within other parts of your project.

#### Create Tabs
```lua
pGui:Init( Layout )

pGui:Init( {
    { Title = 'Title', Height = 500, Single = false }
} )
```

#### Access Tab Elements
```lua
pGui:Handle( Name, Callback, Rightside )

pGui:Handle( 'Title', function( self, Panel )
    self:GenerateLabel( Panel, 'This is a leftside label' )
end )

pGui:Handle( 'Title', function( self, Panel )
    self:GenerateLabel( Panel, 'This is a rightside label' )
end, true )
```

#### Opening
```lua
pGui:Toggle( )
```

## Additional Information

### Documentation

Check the `form` file for the default menu layout used in the screenshots above. Further documentation is located at the top of that file.

### Contributing

Contributions are welcome! If you find a bug or want to add a new feature or element, feel free to fork the repository and submit a pull request.

### License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](./LICENSE) file for more details.
