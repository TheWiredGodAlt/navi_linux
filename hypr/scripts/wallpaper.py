import os
import random
papers = ["win11_2.jpg","LinuxGirl2.jpg","win2000.png","cigarrete.jpg","win11.jpg","animecute.jpg","rei.png","forest.jpg","thecoolest.jpg","mikushop.jpg","coolassanime.jpg","spacemiku2.jpg","cute.jpg"]
wallpaper=random.choice(papers)
file = open("/home/wiredgod/.config/hypr/hyprpaper.conf","w")
file.writelines(
        ["wallpaper{\n"," monitor=HDMI-A-1\n", f"path= ~/Wallpapers/{wallpaper}\n", "fit_mode=center\n","}\n","splash=false"]
        )
file.close()
os.system('killall hyprpaper && hyprpaper')
