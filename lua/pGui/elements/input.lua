function pGui:GenerateInput( Panel, Text, Assignment, Callback )
    -- Have to generate the little input boxes for users to type in.

    Text  = Text  or 'Lorem Ipsum'
    Panel = Panel or self.Last

	local Input = vgui.Create( 'DTextEntry', Panel )
    Input:SetText( Text )
    Input:SetFont( 'DefaultSmall' )
    Input:SetMouseInputEnabled( true )    
    Input:SetKeyboardInputEnabled( true )    
    Input:Dock( RIGHT )
    Input:DockMargin( self:Scale( 5 ), 0, self:Scale( 4 ), 0 )
    Input:SetTall( 15 )
    Input:SetWide( 125 )

    pGui.Config[ Assignment ] = Text

    Input.Paint = function( self, W, H )
        surface.SetDrawColor( 20, 20, 20, 200 )
        surface.DrawRect( 0, 0, W, H )

        surface.SetDrawColor( pGui.Color )
        surface.DrawOutlinedRect( 0, 0, W, H, 1 )

        self:SetTextColor( pGui.Color )
        self:DrawTextEntryText( pGui.Color, pGui.Color, pGui.Color )
    end

    Input.GetTextStyleColor = function( )
        return pGui.Color
    end

    Input.SetTextStyleColor = function( )
        return pGui.Color
    end

	Input.OnEnter = function( self )
        local Value = self:GetValue( )

		pGui.Config[ Assignment ] = Value

        if ( Callback ) then 
            Callback( Value )
        end
	end

    return Input
end