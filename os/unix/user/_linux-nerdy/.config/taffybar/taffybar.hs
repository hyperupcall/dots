import System.Taffybar
import System.Taffybar.Systray
import System.Taffybar.XMonadLog
import System.Taffybar.SimpleClock
import System.Taffybar.Widgets.PollingGraph
import System.Information.CPU

main = do
  let battWid = batteryBarNew defaultBatteryConfig 30
  defaultTaffybar defaultTaffybarConfig { startWidgets = [battWid], barHeight = 25 }
