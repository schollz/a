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
local mxsamples=include("mx.samples/lib/mx.samples")
tabutil=require("tabutil")

engine.name="MxSamples"
skeys=mxsamples:new()

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
  for i=1,4 do
    tracks[i]={notes={},pos_er=0,div=1/8,pos_note=0}
  end
  for _,chord in ipairs(chords) do
    local notes=Music.chord_to_midi(chord)
    for i,note in ipairs(notes) do
      table.insert(tracks[i].notes,note)
      if i==1 and #notes<4 then
        note.m=note.m+12
        table.insert(tracks[4].notes,note)
      end
    end
  end
  tracks[4].div=1/16
  tracks[1].div=1/4

  -- each of the three tracks has its own er
  for i,_ in ipairs(tracks) do
    tracks[i].n=math.random(4,16)
    tracks[i].k=math.random(math.floor(tracks[i].n/4),math.floor(tracks[i].n*3/4))
    tracks[i].w=math.random(1,tracks[i].n-1)
    tracks[i].er=ER.gen(tracks[i].k,tracks[i].n,tracks[i].w)
  end

  play_chord=0
  play_track=1 -- play_track oscillates between the tracks
  play_track_drum=1

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
          for i,t in ipairs(tracks) do
            local note=tracks[i].notes[play_chord]
            local decay=clock.get_beat_sec()*4*2
            if note.is_root then
              local n=note.m
              while n>40 do
                n=n-12
              end
              skeys:on({name="string spurs swells",midi=n,velocity=70,attack=0.5,sustain=0,decay=decay,amp=0.4,reverb_send=0.01})
            else
              --skeys:on({name="string spurs swells",midi=note.m-12,velocity=70,attack=0.2,sustain=0,decay=decay,amp=0.2,reverb_send=0.01})
            end
            -- if note.is_root then
            --   local n=note.m
            --   while n>40 do
            --     n=n-12
            --   end
            --   skeys:on({name="cello",midi=n,velocity=40,attack=clock.get_beat_sec()/2,sustain=0,decay=decay,amp=0.6,reverb_send=0.05})
            --   --engine.mxsamples_bass(note.m-36,0.5,0.2,decay*2)
            -- end
          end
        elseif div==1/2 then
          play_track=(play_track%3)+1
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
      if t.er[tracks[i].pos_er] then
        tracks[i].pos_note=(t.pos_note%#t.notes)+1
        if i==play_track then
          skeys:on({name="steinway model b",midi=t.notes[tracks[i].pos_note].m+12,velocity=70,sustain=0,decay=5,amp=1.2})
        end
        if i==1 then
          skeys:on({name="drums violin",pan=-0.5,midi=t.notes[tracks[i].pos_note].m,velocity=70,sustain=0,decay=1,amp=0.3})
        end
        if i==2 then
          skeys:on({name="drums violin",pan=0.5,midi=t.notes[tracks[i].pos_note].m,velocity=70,sustain=0,decay=1,amp=0.5})
        end
        if i==3 then
          skeys:on({name="drums violin",midi=t.notes[tracks[i].pos_note].m,velocity=70,sustain=0,decay=1,amp=0.5})
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
