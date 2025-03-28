-- Leftside Docked Panels
--    pGui:GenerateButton( Panel, Text, Callback, marginCallback )
--    pGui:GenerateCheckbox( Panel, Text, Assignment, Callback )
--    pGui:GenerateLabel( Panel, Text )

-- Rightside Docked Panels (parented to leftside panels)
--    pGui:GenerateKeybind( Panel, Assignment, Mode, Callback )
--    pGui:GenerateColorpicker( Panel, Assignment, Default, Callback )
--    pGui:GenerateDropdown( Panel, Assignment, Index, Options, Width, useSort, useIndex, Callback )
--    pGui:GenerateInput( Panel, Text, Assignment, Callback )
--    pGui:GenerateMiniCheckbox( Panel, Tooltip, Assignment, Time, Callback )
--    pGui:GenerateSlider( Panel, Assignment, Minimum, Maximum, Default, Decimals, noLabel, Prefix, Callback )

-- Custom Panels (these require some effort to build)
--    pGui:GenerateList( Panel, Name, Callback, createdCallback )
--    pGui:GenerateDraggable( Panel, Title, X, Y, W, H )

-- Call initializer.
pGui:Init( {
    { Title = 'Example', Height = 500, Single = false },
    { Title = 'Example 2', Height = 750, Single = false },
    { Title = 'Example 3', Height = 500, Single = true }
} )

-- Setup Toggle.
concommand.Add( 'pgui_examples', function( )
    pGui:Toggle( )
end )

-- Example.
pGui:Handle( 'Example', function( self, Panel )
    self:GenerateCheckbox( Panel, 'Checkbox', 'example_checkbox', function( )
        MsgN( 'You clicked the example checkbox!' )
        MsgN( 'This is how callbacks work!' )
    end )

    self:GenerateLabel( Panel, 'Example Label' )
    self:GenerateMiniCheckbox( nil, 'Example Minicheckbox', 'example_mini_checkbox' )

    self:GenerateLabel( Panel, 'Example Colorpicker' )
    self:GenerateColorpicker( nil, 'example_colorpicker', self.Colors[ 'Main' ], function( Color )
        self.Color = Color
    end )

    self:GenerateLabel( Panel, 'Example Dropdown' )
    self:GenerateDropdown( nil, 'example_dropdown', 1, {
        'Hello',
        'World',
        '!!!'
    } )

    self:GenerateLabel( Panel, 'Example Binder' )
    self:GenerateKeybind( nil, 'example_binder', 'Always On' )

    self:GenerateLabel( Panel, 'Example Input' )
    self:GenerateInput( nil, 'Hello World!', 'example_input' )

    self:GenerateLabel( Panel, 'Example Slider' )
    self:GenerateSlider( nil, 'example_slider', 0, 100, 50, 0 )

    self:GenerateButton( Panel, 'Example Button', function( )
        MsgN( 'You clicked me!' )
        PrintTable( pGui.Config )
    end )
end )

pGui:Handle( 'Example', function( self, Panel )
    for i = 1, 100 do 
        self:GenerateLabel( Panel, 'Example #' .. i ) 
    end
end, true )

-- Example 3.
pGui:Handle( 'Example 3', function( self, Panel )
    self:GenerateList( Panel, 'Example List', nil, function( self )
        for i = 1, 100 do 
            pGui:GenerateListElement( self, 'List Example #' .. i )
        end
    end )
end )