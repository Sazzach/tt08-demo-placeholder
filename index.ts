// For use with vga_playground: https://github.com/TinyTapeout/vga-playground 

import project_v from './src/project.v?raw';
import vga_timing_v from './src/vga_timing.v?raw';

export const demo = {
  name: 'demo',
  author: 'sazzach',
  topModule: 'tt_um_example',
  sources: {
    'project.v': project_v,
    'vga_timing.v': vga_timing_v,
  },
};
