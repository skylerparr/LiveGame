var project = new Project('Empty');

project.addAssets('Assets/**');
project.addSources('Sources');
project.addLibrary('minject');

return project;
