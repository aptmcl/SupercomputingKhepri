# This file was generated, do not modify it. # hide
#hideall
plot_povray_speedup(raw_data1, raw_data2) =
  let process_data(raw_data) =
            sort(combine(groupby(raw_data, :TraceThreads),
                         :RealTime => it->mean(map(time2seconds, it))),
                 :TraceThreads),
      data1 = process_data(raw_data1),
      data2 = process_data(raw_data2)
    plot(data1[:,1],
         [map(x->data1[1,2]/x, data1[:,2]) map(x->data2[1,2]/x, data2[:,2])],
         xticks=data1[:,1],
         label=["1024x768" "1920x1024"],
         legend=:topleft,
         markers=:auto,
         #ylimits=(0,180),
         xlabel="Threads",
         #color=:green,
         #xscale=:log10,
         ylabel="Time (s)")
  end

average96 =
  combine(filter(:TraceThreads => x->x==96, povray_1920x1024),
          :RealTime => it->mean(map(time2seconds, it)))

plt = plot_povray_speedup(povray_1024x768, povray_1920x1024)
saveplot(plt,"POVRay1024x768vs1920x1024")