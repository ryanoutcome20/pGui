pGui = { 
    Resolution = {
        Height = ScrH( ),
        Width  = ScrW( )
    },

    Colors = {
        [ 'Main' ] = Color( 255, 80, 80 ), 

        [ 'White' ]     = Color( 255, 255, 255 ),
        [ 'Black' ]     = Color( 0, 0, 0 ),
        [ 'Gray' ]      = Color( 30, 30, 30 ),
        [ 'Invisible' ] = Color( 0, 0, 0, 0 ),
    
        [ 'Light Gray' ] = Color( 80, 80, 80 ),
        [ 'Dark Gray' ]  = Color( 18, 18, 18 ),
        [ 'Cyan' ]       = Color( 60, 180, 225 ),
        [ 'Purple' ]     = Color( 133, 97, 136 ),
    
        [ 'Red' ]   = Color( 255, 0, 0 ),
        [ 'Green' ] = Color( 0, 255, 0 ),
        [ 'Blue' ]  = Color( 0, 0, 255 )
    },

    Config     = { },

    Gradients = {
        Up     = Material( 'vgui/gradient_up' ),
        Down   = Material( 'vgui/gradient_down' ),
        Left   = Material( 'vgui/gradient-l' ),
        Right  = Material( 'vgui/gradient-r' ),
        Uni    = Material( 'vgui/gradient-u' ),
        Center = Material( 'gui/center_gradient' ),
        Grid   = Material( 'gui/alpha_grid.png', 'nocull' )
    },

    Background = NULL,
    Bottom     = NULL,
    Active     = NULL,
    Last       = NULL,
    
    Tabs    = { },
    Toggles = { },
    Held    = { }
}

pGui.Color  = pGui.Colors[ 'Main' ]
pGui.Copied = pGui.Colors[ 'Main' ]

include( 'elements/tabs.lua' )
include( 'elements/list.lua' )
include( 'elements/label.lua' )
include( 'elements/input.lua' )
include( 'elements/slider.lua' )
include( 'elements/button.lua' )
include( 'elements/binder.lua' )
include( 'elements/checkbox.lua' )
include( 'elements/dropdown.lua' )
include( 'elements/draggable.lua' )
include( 'elements/colorpicker.lua' )
include( 'elements/minicheckbox.lua' )

function pGui:Print( isError, Text, ... )
    local Prefix = isError and '[ ERROR ]' or '[ PGUI ]'
    local Color  = isError and self.Colors[ 'Red' ] or self.Colors[ 'Main' ]

    MsgC( Color, Prefix, ' ', self.Colors[ 'White' ], string.format( Text, ... ), '\n' )
end

function pGui:Scale( Size )
    return math.max( Size * ( self.Resolution.Height / 1080 ), 1 )
end

function pGui:Init( Tabs )
    if ( not istable( Tabs ) ) then 
        return pGui:Print( true, 'Invalid tab layout passed to menu initializer "%s"!', type( Tabs ) )
    end

    -- Generate the background.
    local Background = vgui.Create( 'DPanel' )
    Background:SetSize( self.Resolution.Width, self.Resolution.Height )
    Background:SetMouseInputEnabled( true )
    Background:SetKeyboardInputEnabled( true )
    Background:SetVisible( false )
    Background.Paint = function( self, W, H )
        surface.SetDrawColor( 0, 0, 0, 180 )
        surface.DrawRect( 0, 0, W, H )
    end

    self.Background = Background

    -- Get the bottom bar size.
    local Offset = self:Scale( 40 )

    -- Generate the bottom tab selector.
    local Bottom = vgui.Create( 'DFrame', Background )
	Bottom:SetSize( self.Resolution.Width, Offset )
	Bottom:SetPos( 0, self.Resolution.Height - ( Offset / 2 ) )
	Bottom:SetTitle( '' )
	Bottom:SetDraggable( false )
    Bottom:ShowCloseButton( false )
    Bottom:MakePopup( )
    Bottom:DockPadding( 0, 0, 0, 0 )

    Bottom.Paint = function( self, W, H )
        surface.SetMaterial( pGui.Gradients.Left )
        surface.SetDrawColor( 17, 17, 17 )
        surface.DrawTexturedRect( 0, 0, W, H )

        surface.SetMaterial( pGui.Gradients.Right )
        surface.SetDrawColor( 17, 17, 17 )
        surface.DrawTexturedRect( 0, 0, W, H )

        surface.SetMaterial( pGui.Gradients.Center )
        surface.SetDrawColor( pGui.Color )
        surface.DrawTexturedRect( 0, 0, W, 2 )
    end

    self.Bottom = Bottom
    
    -- Generate our tabs.
    for i = 0, #Tabs - 1 do 
        local Index = Tabs[ i + 1 ]

        self:GenerateTab( Index.Title, 750, Index.Height, Index.Single )

        local TabButton = vgui.Create( 'DButton', Bottom )
        TabButton:SetText( Index.Title )
        TabButton:SetTextColor( self.Colors[ 'White' ] )
        TabButton:SetFont( 'DefaultSmall' )
        TabButton:SizeToContents( )
        TabButton:Dock( LEFT )
        TabButton:DockMargin( 0, -self:Scale( 20 ), self:Scale( 5 ), 0 )
        
        TabButton.Paint = function( self, W, H ) 
            self:SetColor( pGui.Colors[ 'White' ] )
        end

        TabButton.DoClick = function( self, W, H )
            local Frame = pGui.Tabs[ Index.Title ].Parent

            Frame:MakePopup( )

            if ( Frame:IsVisible( ) ) then 
                Frame:AlphaTo( 0, 0.15, 0, function( Data, Panel ) 
                    Panel:ToggleVisible( )
                end )
            else
                Frame:ToggleVisible( )
                Frame:SetAlpha( 0 )
                Frame:AlphaTo( 255, 0.15, 0 )
            end
        end
    end

    -- Generate the timestamp.
    local Timestamp = vgui.Create( 'DLabel', Bottom )
    Timestamp:Dock( RIGHT )
    Timestamp:DockMargin( 0, -self:Scale( 20 ), -self:Scale( 15 ), 0 )
    Timestamp:SetText( '' )
    Timestamp:SetMouseInputEnabled( true )
    Timestamp:SetCursor( 'hand' )

    Timestamp.DoClick = function( self )
        pGui:Toggle( )
    end

    Timestamp.Paint = function( self, W, H ) 
        self:SetColor( pGui.Colors[ 'White' ] )
    end
    
    Timestamp.Think = function( self )
        self:SetText( os.date( '%X' ) )
    end
end

function pGui:Handle( Title, Callback, Side )
    local Tab = self.Tabs[ Title ]

    if ( not Tab ) then 
        return
    end

    Callback( self, Side and Tab.RightS or Tab.LeftS )
end

function pGui:Toggle( )
    self.Background:ToggleVisible( )

    for k, Tab in pairs( self.Tabs ) do 
        Tab.Parent:SetVisible( false )
    end
end

include( 'form.lua' )