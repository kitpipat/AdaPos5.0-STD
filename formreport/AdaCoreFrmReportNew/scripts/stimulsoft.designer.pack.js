/*
Stimulsoft.Reports.JS
Version: 2022.1.4
Build date: 2022.01.14
License: https://www.stimulsoft.com/en/licensing/reports
*/
!function(v){var f;"object"==typeof exports&&"undefined"!=typeof module?module.exports=(f=require("./stimulsoft.viewer.pack"),Object.assign(f,v(f.Stimulsoft))):"function"==typeof define&&define.amd?define(["./stimulsoft.viewer.pack"],f=>Object.assign(f,v(f.Stimulsoft))):Object.assign(window,v(window.Stimulsoft))}(function(f){var v={Stimulsoft:f||{}};if(
,v.Stimulsoft.decodePackedData&&v.Stimulsoft.Viewer)for(const t of["designerScript","blocklyScript"])v.Stimulsoft[t]&&Object.assign(v,v.Stimulsoft.decodePackedData(v.Stimulsoft[t])(v.Stimulsoft)),delete v.Stimulsoft[t];return v});