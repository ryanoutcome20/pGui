function pGui:GenerateKeybind( Panel, Assignment, Mode, Callback )
    -- Have to generate the keybinders used in the menu.
    
    Panel = Panel or self.Last

    local Binder = vgui.Create( 'DBinder', Panel )
    Binder:SetFont( 'DefaultSmall' )
    Binder:SetSize( 25, 15 )
    Binder:SetText( '' )
    Binder:Dock( RIGHT )
    Binder:DockMargin( self:Scale( 5 ), 0, self:Scale( 4 ), 0 )

    pGui.Config[ Assignment ] = 0
    pGui.Config[ Assignment .. ' Mode' ] = Mode and Mode or 'Hold'

    Binder.Paint = function( self, W, H )
        surface.SetDrawColor( 20, 20, 20, 200 )
        surface.DrawRect( 0, 0, W, H )

        surface.SetDrawColor( pGui.Color )
        surface.DrawOutlinedRect( 0, 0, W, H, 1 )

        self:SetTextColor( pGui.Color )
    end
    
    Binder.UpdateText = function( self )
        local Name = input.GetKeyName( self:GetSelectedNumber( ) )

        if ( not Name ) then 
            return
        end

        Name = language.GetPhrase( Name )
        
        self:SetText( Name )
        self:SetWide( math.max( math.Clamp( #Name, 1, 9 ) * pGui:Scale( 9 ), 25 ) )
    end

    Binder.DoClick = function( self )
        self:SetText( '...' )
        input.StartKeyTrapping( )
        self.Trapping = true
    end

    Binder.DoRightClick = function( self )
        pGui:GenerateKeybindSubpanel( Panel, Assignment )
    end

    Binder.GetTextStyleColor = function( )
        return pGui.Color
    end

    Binder.SetTextStyleColor = function( )
        return pGui.Color
    end

    Binder.OnChange = function( self, Key )
        pGui.Config[ Assignment ] = Key

        if ( Callback ) then 
            Callback( Key )
        end
    end

    return Binder
end

function pGui:GenerateKeybindSubpanel( Panel, Assignment )
    -- Have to generate the keybind style menu.

    -- Get main frame that everything will parent too.
    local Frame = vgui.Create( 'DPanel', Panel )
    Frame:SetPos( gui.MouseX( ), gui.MouseY( ) )
    Frame:SetSize( self:Scale( 125 ), self:Scale( 15 ) )
    Frame:MakePopup( )

    Frame.Paint = function( self, W, H ) 
        surface.SetDrawColor( 20, 20, 20 )
        surface.DrawRect( 0, 0, W, H )

        surface.SetDrawColor( pGui.Color )
        surface.DrawOutlinedRect( 0, 0, W, H, 1 )
    end

    Frame.Think = function( self )
        local Parent = self:GetParent( )

        if ( Parent and not Parent:IsVisible( ) ) then 
            return self:Remove( )
        end

        if ( not input.IsMouseDown( MOUSE_LEFT ) and not input.IsMouseDown( MOUSE_RIGHT ) ) then
            return 
        end

        if ( not self:IsHovered( ) and not self:IsChildHovered( ) ) then 
            self:Remove( )
        end
    end

    -- Generate our dropdown.
    local Dropdown = vgui.Create( 'DComboBox', Frame )
    Dropdown:Dock( FILL )
    Dropdown:DockMargin( 0, 0, 0, 0 )

    Dropdown:SetFont( 'DefaultSmall' )

    Dropdown:AddChoice( 'Hold' )
    Dropdown:AddChoice( 'Hold Off' )
    Dropdown:AddChoice( 'Toggle' )
    Dropdown:AddChoice( 'Always On' )

    Dropdown:SetValue( pGui.Config[ Assignment .. ' Mode' ] )

    Dropdown.OnSelect = function( self, Index, Value )
        pGui.Config[ Assignment .. ' Mode' ] = Value
    end

    self:GenerateFixedDropdown( Dropdown )
end

function pGui:Keydown( Assignment )
    local Key, Mode = pGui.Config[ Assignment ], pGui.Config[ Assignment .. ' Mode' ]

    if ( not Key or not Mode ) then 
        return false
    end

    if ( Mode == 'Always On' ) then 
        return true 
    elseif ( Mode == 'Hold Off' ) then
        return not input.IsButtonDown( Key )
    elseif ( Mode == 'Hold' ) then
        return input.IsButtonDown( Key )
    elseif ( Mode == 'Toggle' ) then
        return self.Toggles[ Key ]
    end

    return false
end

function pGui:HandleToggles( )
    for Key = 1, BUTTON_CODE_LAST do
        self.Toggles[ Key ] = self.Toggles[ Key ] or false 

        if ( not input.IsButtonDown( Key ) ) then 
            self.Held[ Key ] = false
            continue
        end

        if ( self.Held[ Key ] ) then 
            continue
        end

        if ( self.Toggles[ Key ] ) then 
            self.Toggles[ Key ] = false 
        else 
            self.Toggles[ Key ] = true 
        end

        self.Held[ Key ] = true
    end
end

hook.Add( 'Tick', 'pGui', function( )
    pGui:HandleToggles( )
end )