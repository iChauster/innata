## innata

rethink finance

## screnshots
<img src = "/screenshots/Simulator Screen Shot Jan 21, 2017, 9.47.12 PM.png" width="258px">
<img src = "/screenshots/Simulator Screen Shot Jan 28, 2017, 4.21.21 PM.png" width = "258px">

An app to keep you on track using receipt scanners, and spending heat maps and graphs.

We used TesseractOCR to process images and retrieve the spending from receipts. The image processing was very difficult, and was innacurate at times, especially with complex images. However, it was useful for simple, clear receipts.

The Nessie API allowed us to get users's purchases and analyze them. We decided to create Heat Maps (LFHeatMap) and graphs of weekly spending (AndroidCharts).

We sorted by GeoCode, and also by Date, which was provided by the NessieAPI. 



