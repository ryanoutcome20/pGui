function pGui:GenerateDraggable( Panel, Title, X, Y, W, H )
    -- Have to generate the dragable menu elements that you can use for things like spectator
    -- lists.

    local baseW   = W or 120
    local baseH   = H or 15
    local Padding = 2

    X = X or 0
    Y = Y or 0

    local Draggable = vgui.Create( 'DFrame', Panel )
    Draggable:SetSize( baseW, baseH )
    Draggable:SetPos( X, Y )
    Draggable:SetTitle( '' )
    Draggable:ShowCloseButton( false )
    Draggable:SetDraggable( true )
    Draggable:DockPadding( 2, baseH, 0, 0 )

    Draggable.Paint = function( self, W, H )
        surface.SetDrawColor( 18, 18, 18, 150 )
        surface.DrawRect( 0, 0, W, H )

        surface.SetMaterial( pGui.Gradients.Right )
        surface.SetDrawColor( pGui.Color )
        surface.DrawTexturedRect( 0, 0, W, baseH )

        surface.DrawOutlinedRect( 0, 0, W, H, 1 )

        surface.SetTextColor( pGui.Colors[ 'White' ] )

        surface.SetFont( 'DefaultSmall' )
        surface.SetTextPos( 2, 2 ) 
        surface.DrawText( Title )
    end

    Draggable.Indexes = { }

    Draggable.Update = function( self )
        local W, H = 0, 0

        for k, v in ipairs( self.Indexes ) do 
            local Wide, Tall = v:GetSize( )

            if ( Wide > W ) then 
                W = Wide
            end

            H = H + Tall
        end

        if ( W < baseW ) then 
            W = 0
        end

        if ( H != 0 ) then 
            H = H + Padding
        end

        self:SetSize( W + baseW, H + baseH )
    end

    Draggable.AddIndex = function( self, Name, overrideColor )
        local Label = vgui.Create( 'DLabel', self )
        Label:SetText( Name )
        Label:SetFont( 'DefaultSmall' )
        Label:SizeToContents( )
        Label:SetMouseInputEnabled( true )    
        Label:Dock( TOP )
        Label:DockMargin( 0, 0, 0, 0 )

        Label.Think = function( self )
            if ( overrideColor ) then 
                self:SetTextColor( overrideColor )
            else
                self:SetTextColor( pGui.Colors[ 'White' ] )
            end
        end

        table.insert( self.Indexes, Label )

        self:Update( )
    end

    Draggable.AddPanel = function( self, Panel )
        table.insert( self.Indexes, Panel )

        self:Update( )
    end

    Draggable.AddIndexes = function( self, Table )
        for k,v in pairs( Table ) do 
            self:AddIndex( v )
        end
    end

    Draggable.ClearIndexes = function( self )
        for k, Panel in ipairs( self.Indexes ) do 
            Panel:Remove( )
        end

        self.Indexes = { }

        self:Update( )
    end

    Draggable.RemoveIndex = function( self, Name )
        local Copy = { }

        for k, Panel in ipairs( self.Indexes ) do 
            if ( Panel:GetText( ) == Name ) then 
                Panel:Remove( )
            else
                table.insert( Copy, Panel )
            end
        end

        self.Indexes = Copy

        self:Update( )
    end

    return Draggable
end