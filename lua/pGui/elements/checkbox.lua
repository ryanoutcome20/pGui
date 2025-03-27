function pGui:GenerateCheckbox( Panel, Text, Assignment, Callback )
    -- Have to generate the checkboxes used in the menu.

    -- Generate main checkbox handler.
	local Checkbox = vgui.Create( 'DCheckBoxLabel', Panel )
	Checkbox:Dock( TOP )
    Checkbox:DockMargin( 0, 0, 0, self:Scale( 5 ) )
	Checkbox:SetText( Text )
	Checkbox:SetValue( pGui.Config[ Assignment ] )
	Checkbox:SizeToContents( )
    
    Checkbox.OnChange = function( self, Value )
        pGui.Config[ Assignment ] = Value

        if ( Callback ) then 
            Callback( Value )
        end
    end
    
    -- Fix layout and painting on button.
    Checkbox.Button:Dock( LEFT )

    Checkbox.Button.Paint = function( self, W, H )
        surface.SetDrawColor( pGui.Config[ Assignment ] and pGui.Color or pGui.Colors[ 'Dark Gray' ] )
        surface.DrawRect( 0, 0, W, H )

        surface.SetDrawColor( pGui.Color )
        surface.DrawOutlinedRect( 0, 0, W, H, 1 )
    end

    -- Fix font and layout on label.
    Checkbox.Label:SetFont( 'DefaultSmall' )
    Checkbox.Label:Dock( LEFT )
    Checkbox.Label:DockMargin( self:Scale( 5 ), 0, 0, 0 )

    Checkbox.Label.Think = function( self )
        self:SetTextColor( pGui.Colors[ 'White' ] )
    end

    -- Set our last for the right docking elements.
    self.Last = Checkbox

    return Checkbox
end