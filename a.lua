-- new script v0.0.1
-- ?
--
-- llllllll.co/t/?
--
--
--
--    ▼ instructions below ▼
--
-- ?

local shift=false
local Lattice=require("lattice")
local ER=require("er")
local Music=include("a/lib/music")

function init()
  -- initialize metro for updating screen
  timer=metro.init()
  timer.time=1/15
  timer.count=-1
  timer.event=update_screen
  timer:start()

  -- initialize 3 tracks. each track has one note of chord
  local chords={"Am/C","F/C","C","G"}
  tracks={}
  for i=1,3 do
    tracks[i]={notes={},pos_er=0,div=1/8,pos_note=0}
  end
  for _,chord in ipairs(chords) do
    for i,note in ipairs(Music.chord_to_midi(chord)) do
      table.insert(tracks[i].notes,note.m)
    end
  end

  -- each of the three tracks has its own er
  for i=1,3 do
    tracks[i].n=math.random(4,16)
    tracks[i].k=math.random(1,math.floor(n/2)+1)
    tracks[i].w=math.random(1,n-1)
    tracks[i].er=ER.gen(tracks[i].k,tracks[i].n,tracks[i].w)
  end

  play_chord=0
  play_track=1 -- play_track oscillates between the tracks

  -- intialize timekeeper
  timekeeper=Lattice:new()
  local divisions={1/32,1/16,1/8,1/4,1/2,1}
  for _,div in ipairs(divisions) do
    timekeeper:new_pattern{
      action=function(t)
        emit(div)
        if div==1 then
          -- iterate to next chord
          play_chord=(play_chord%4)+1
          for _,t in tracks[i] do
            local note=tracks[i].notes[play_chord]
            local decay=clock.get_beat_sec()*4
            skeys:on({name="string spurs swells",midi=note,velocity=70,attack=2,sustain=0,decay=decay,amp=0.5,reverb_send=0.02})
          end
        end
      end,
      division=div,
    }
  end
  timekeeper:start()

end

function emit(div)
  for i,t in ipairs(tracks) do
    if t.div==div then
      tracks[i].pos_er=(t.pos_er%t.n)+1
      -- TODO: check if its 1 or "true"
      if t.er[tracks.pos] then
        tracks[i].pos_note=(t.pos_note%#t.notes)+1
        if i==play_track then
          skeys:on({name="ghost piano",midi=t.notes[tracks[i].pos_note]+24,velocity=70,sustain=0,decay=5,delay_send=0.00,amp=0.6})
        end
      end
    end
  end
end

function update_screen()
  redraw()
end

function key(k,z)
  if k==1 then
    shift=z==1
  end
  if shift then
    if k==1 then
    elseif k==2 then
    else
    end
  else
    if k==1 then
    elseif k==2 then
    else
    end
  end
end

function enc(k,d)
  if shift then
    if k==1 then
    elseif k==2 then
    else
    end
  else
    if k==1 then
    elseif k==2 then
    else
    end
  end
end

function redraw()
  screen.clear()

  screen.update()
end

function rerun()
  norns.script.load(norns.state.script)
end
