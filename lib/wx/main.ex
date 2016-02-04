defmodule Oscillixir.Wx.Main do

  use Oscillixir.Wx.Imports

  @title 'Oscillixir'

  @start 10
  @stop 11

  def on_key do
    IO.inspect("i got teh kez")
  end


  def run do
    wx = :wx.new()
    frame = :wxFrame.new(wx, -1, @title)
    panel = :wxPanel.new(frame)
    main_sizer = :wxBoxSizer.new(:wx_const.wx_vertical)

    canvas_sizer = :wxStaticBoxSizer.new(:wx_const.wx_vertical, panel, label: "Oscillixir")
    canvas_panel = :wxPanel.new(panel, style: :wx_const.wx_full_repaint_on_resize, size: {1000,1000})
    :wxPanel.connect(canvas_panel, :paint, [:callback])
    :wxSizer.add(canvas_sizer, canvas_panel, flag: :wx_const.wx_expand, proportion: 1)

    start_button = :wxButton.new(frame, @start, label: 'Start')
    stop_button = :wxButton.new(frame, @stop, label: 'Stop')

    :wxSizer.add(main_sizer, start_button)
    :wxSizer.add(main_sizer, stop_button)

    :wxSizer.add(main_sizer, canvas_sizer)
    :wxSizer.add(main_sizer, canvas_sizer, flag: :wx_const.wx_expand, proportion: 1)


    :wxPanel.setSizer(panel, main_sizer)
    :wxSizer.layout(main_sizer)

    :wxWindow.connect(frame, :close_window)
#    :wxWindow.connect(frame, :motion)


    :wxPanel.connect(frame, :paint, [:callback])
    :wxFrame.connect(frame, :command_button_clicked)
    for action <- [:key_down, :key_up, :char] do
      :wxWindow.connect(frame, action)
    end

    :wxFrame.show(frame)
#    dc = :wxPaintDC.new(frame)
#    canvas = :wxGraphicsContext.create(dc)

    dc = :nil
    canvas = :nil

    loop({dc, canvas})

#    :wxPaintDC.destroy(dc)
    :wxFrame.destroy(frame)
  end


  def loop({dc, canvas}) do
    receive do
      wx(event: wxClose()) ->
        IO.puts "close_window received"

      wx_event = wx() ->
        IO.inspect(wx_event)
        IO.puts "other event received"
        loop({dc, canvas})

      event ->
        IO.inspect(event)
        IO.puts "event received"
        loop({dc, canvas})

    end
  end

end
