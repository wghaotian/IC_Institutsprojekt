% gx = geoaxes;
% latAachen = 50.775555;
% lonAachen = 6.083611;
% latKoeln = 50.935173;
% lonKoeln = 6.953101;
% geoplot(gx,[latAachen latKoeln],[lonAachen lonKoeln],'g-*')
% geobasemap(gx,'topographic')

visualization;
gx = geoaxes(app.Panel);
latAachen = 50.775555;
lonAachen = 6.083611;
latKoeln = 50.935173;
lonKoeln = 6.953101;
geoplot(gx,[latAachen latKoeln],[lonAachen lonKoeln],'g-*')
geobasemap(gx,'topographic')