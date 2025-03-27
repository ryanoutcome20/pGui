function pGui:GenerateButton( Panel, Text, Callback, marginCallback )
    -- Have to generate the buttons used in the menu.
    
    local Button = vgui.Create( 'DButton', Panel or self.Last )
    Button:SetFont( 'DefaultSmall' )
    Button:SetText( Text )
    Button:Dock( TOP )

    if ( not isfunction( marginCallback ) ) then 
        Button:DockMargin( 0, 0, self:Scale( 4 ), self:Scale( 5 ) )
    else 
        marginCallback( Button )
    end

    Button.Paint = function( self, W, H )
        surface.SetDrawColor( 20, 20, 20, 200 )
        surface.DrawRect( 0, 0, W, H )

        surface.SetDrawColor( pGui.Color )
        surface.DrawOutlinedRect( 0, 0, W, H, 1 )

        self:SetTextColor( pGui.Color )
    end

    Button.GetTextStyleColor = function( )
        return pGui.Color
    end

    Button.SetTextStyleColor = function( )
        return pGui.Color
    end

    Button.DoClick = Callback or function( self ) end

    return Button
end