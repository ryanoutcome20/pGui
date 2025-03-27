function pGui:GenerateList( Panel, Name, Callback, createdCallback )
    -- Have to generate the listboxes used in the menu.

    local DCollapsible = vgui.Create( 'DCollapsibleCategory', Panel )
    DCollapsible:SetLabel( Name )
    DCollapsible:Dock( TOP )
    DCollapsible:SetExpanded( false )
    DCollapsible:SetPaintBackground( false )
    DCollapsible:Toggle( )

    DCollapsible.SetExpanded = function( self )

    end

    DCollapsible.Paint = function( self, W, H )
        surface.SetDrawColor( 20, 20, 20, 120 )
        surface.DrawRect( 0, 0, W, H )

        self.Header:SetTextColor( pGui.Colors[ 'White' ] )
        
        if ( Callback ) then
            Callback( self, Name )
        end
    end

    if ( createdCallback ) then 
        createdCallback( DCollapsible, Name )
    end
    
    return DCollapsible
end

function pGui:GenerateListElement( Panel, Text, activeCallback )
    local Button = Panel:Add( Text )

    Button.Paint = function( self, W, H )
        if ( activeCallback and activeCallback( Text ) ) then 
            self:SetTextColor( pGui.Color )
        elseif ( self.Depressed or self.m_bSelected ) then 
            self:SetTextColor( pGui.Colors[ 'White' ] )
        else 
            self:SetTextColor( pGui.Colors[ 'Light Gray' ] )
        end
    end
end