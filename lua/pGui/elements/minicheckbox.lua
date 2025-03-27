function pGui:GenerateMiniCheckbox( Panel, Tooltip, Assignment, Time, Callback )
    -- Have to generate the small checkboxes next to main menu elements.

    Panel = Panel or self.Last

    Time  = Time or 0.3

    -- Generate main checkbox handler.
    local Checkbox = vgui.Create( 'DCheckBox', Panel )
	Checkbox:Dock( RIGHT )
    Checkbox:DockMargin( self:Scale( 5 ), 0, self:Scale( 4 ), 0 )
	Checkbox:SetValue( pGui.Config[ Assignment ] )

    Checkbox.OnChange = function( self, Value )
        pGui.Config[ Assignment ] = Value

        if ( Callback ) then
            Callback( Value )
        end
    end

    -- Setup our hover think.
    -- Can't use tooltips since the engine handles most of it and trying to paint over it
    -- will be overriden with the engines yellow color scheme.
    Checkbox.Hover, Checkbox.Timer = self:GenerateMiniCheckboxTooltip( Panel, Tooltip ), CurTime( )

    Checkbox.Paint = function( self, W, H )
        surface.SetDrawColor( pGui.Config[ Assignment ] and pGui.Color or pGui.Colors[ 'Dark Gray' ] )
        surface.DrawRect( 0, 0, W, H )

        surface.SetDrawColor( pGui.Color )
        surface.DrawOutlinedRect( 0, 0, W, H, 1 )

        if ( self:IsHovered( ) or self:IsChildHovered( ) ) then 
            if ( self.Timer + Time < CurTime( ) ) then 
                self.Hover:SetVisible( true )
                self.Hover:MakePopup( )
                
                self.Hover:SetPos( gui.MouseX( ), gui.MouseY( ) - pGui:Scale( 25 ) )
            end
        else             
            self.Timer = CurTime( )

            self.Hover:SetVisible( false ) 
        end
    end
end

function pGui:GenerateMiniCheckboxTooltip( Panel, Tooltip )
    local Frame = vgui.Create( 'DPanel', Panel )
    Frame:SetSize( self:Scale( 80 ), self:Scale( 20 ) )
    Frame:MakePopup( )
    Frame:SetVisible( false )

    Frame.Paint = function( self, W, H ) 
        surface.SetDrawColor( 20, 20, 20, 200 )
        surface.DrawRect( 0, 0, W, H )

        surface.SetDrawColor( pGui.Color )
        surface.DrawOutlinedRect( 0, 0, W, H, 1 )

        surface.SetFont( 'DefaultSmall' )
        surface.SetTextColor( pGui.Color )
        surface.SetTextPos( 2, 2 ) 
        surface.DrawText( Tooltip )

        -- There is a natural 1,1 offset of drawn text. Therefore three here is correct. We'll use five
        -- for some extra padding.
        self:SetWide( surface.GetTextSize( Tooltip ) + 5 )
    end

    return Frame
end