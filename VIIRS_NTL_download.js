// Harris County boundary must already exist as 'geometry' or in Assets.

// VIIRS monthly nighttime lights
var viirs = ee.ImageCollection('NOAA/VIIRS/DNB/MONTHLY_V1/VCMSLCFG')
  .filterDate('2017-07-01', '2018-08-01')   // end date is exclusive
  .select('avg_rad');

// Start date
var startDate = ee.Date('2017-08-01');
var nMonths = 14;   

for (var i = 0; i < nMonths; i++) {
  var start = startDate.advance(i, 'month');
  var end = start.advance(1, 'month');

  var img = viirs.filterDate(start, end).first();

  var monthStr = start.format('YYYY_MM').getInfo();

  Export.image.toDrive({
    image: ee.Image(img).clip(geometry),
    description: 'VIIRS_' + monthStr,
    folder: 'VIIRS_Harris_Exports1',
    fileNamePrefix: 'VIIRS_' + monthStr,
    region: geometry,
    scale: 500,
    maxPixels: 1e13,
    fileFormat: 'GeoTIFF'
  });
}
