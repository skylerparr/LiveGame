var project = new Project('Empty');

project.addAssets('Assets/**');
project.addSources('Sources');
project.addLibrary('minject');
project.addLibrary('continuation');
project.addLibrary('actuate');

return project;
