{
    "stream_profile": {
        "name": "imx283_sensor",
        "stream_groups": [
            {
                "id": "still_3x2",
                "shooter_id": "still-general",
                "shooter_param": "res=3x2;normal_cap=offline;",
                "still_raw_process_pipe": [
                    {
                        "id": "raw_process_pipe",
                        "nodes": [
                            {
                                "id": "input",
                                "param": ""
                            },
                            {
                                "id": "ob",
                                "param": "output_buffer_nr=2;dsp_cores=16;outstanding_mask=100663296;"
                            }
                        ]
                    }
                ],
                "still_process_pipe": [
                    {
                        "id": "main_pipe",
                        "nodes": [
                            {
                                "id": "input",
                                "param": ""
                            },
                            {
                                "id": "tino",
                                "param": "output_buffer_nr=1;dsp_cores=16;outstanding_mask=100663296;"
                            }
                        ]
                    },
                    {
                        "id": "aeb_pipe",
                        "nodes": [
                            {
                                "id": "input",
                                "param": ""
                            },
                            {
                                "id": "tino",
                                "param": "output_buffer_nr=1;dsp_cores=16;outstanding_mask=100663296;"
                            }
                        ]
                    }
                ],
                "sensor_fps": "DCAM_FPS_2500",
                "filters": [
                    {
                        "type": "dzoom",
                        "id": "dzoom_1",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "disp_eng",
                        "id": "disp_eng_1",
                        "style": "listen",
                        "parameter": "name=wm232;"
                    }
                ],
                "streams": [
                    {
                        "id": "liveview",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_LIVEVIEW",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2500",
                        "width": 1632,
                        "height": 1088,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "vmem_flag": 31,
                        "buffer_nr": 11,
                        "priority": "high",
                        "sink_filters": [
                            {
                                "filter_id": "disp_eng_1",
                                "port_index": 0
                            }
                        ]
                    },
                    {
                        "id": "still_yuv",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_STILL",
                        "behavior": "DCAM_STREAM_BEHAVIOR_PERREQUEST",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_1500",
                        "width": 5472,
                        "height": 3648,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "vmem_flag": 31,
                        "priority": "high",
                        "buffer_nr": 8
                    },
                    {
                        "id": "still_raw",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_STILL",
                        "behavior": "DCAM_STREAM_BEHAVIOR_PERREQUEST",
                        "format": "DUSS_PIXFMT_RAW16_OPAQUE",
                        "fps": "DCAM_FPS_1500",
                        "width": 5568,
                        "height": 3648,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "vmem_flag": 31,
                        "priority": "high",
                        "buffer_nr": 8
                    },
                    {
                        "id": "navigation",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_VISION",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2500",
                        "width": 1280,
                        "height": 852,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "vmem_flag": 31,
                        "buffer_nr": 10,
                        "sink_filters": [
                            {
                                "filter_id": "dzoom_1",
                                "port_index": 0
                            }
                        ]
                    },
                    {
                        "id": "vision",
                        "type": "DCAM_STREAM_TYPE_FILTER",
                        "usage": "DCAM_STREAM_USAGE_VISION",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2500",
                        "width": 640,
                        "height": 426,
                        "width_alignment": 128,
                        "height_alignment": 480,
                        "vmem_flag": 31,
                        "buffer_nr": 10,
                        "source_filter": {
                            "filter_id": "dzoom_1",
                            "port_index": 0
                        }
                    }
                ]
            },
            {
                "id": "still_fcali_full",
                "shooter_id": "still-general",
                "shooter_param": "res=fcali_full;normal_cap=offline;",
                "still_process_pipe": [
                    {
                        "id": "main_pipe",
                        "nodes": [
                            {
                                "id": "input",
                                "param": ""
                            }
                        ]
                    },
                    {
                        "id": "aeb_pipe",
                        "nodes": [
                            {
                                "id": "input",
                                "param": ""
                            }
                        ]
                    }
                ],
                "sensor_fps": "DCAM_FPS_2997",
                "filters": [
                    {
                        "type": "dzoom",
                        "id": "dzoom_1",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "disp_eng",
                        "id": "disp_eng_1",
                        "style": "listen",
                        "parameter": "name=wm232;"
                    }
                ],
                "streams": [
                    {
                        "id": "liveview",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_LIVEVIEW",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2997",
                        "width": 1632,
                        "height": 1088,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "vmem_flag": 31,
                        "buffer_nr": 11,
                        "sink_filters": [
                            {
                                "filter_id": "disp_eng_1",
                                "port_index": 0
                            }
                        ]
                    },
                    {
                        "id": "still_yuv",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_STILL",
                        "behavior": "DCAM_STREAM_BEHAVIOR_PERREQUEST",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2000",
                        "width": 5472,
                        "height": 3648,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "vmem_flag": 31,
                        "buffer_nr": 8
                    },
                    {
                        "id": "still_raw",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_STILL",
                        "behavior": "DCAM_STREAM_BEHAVIOR_PERREQUEST",
                        "format": "DUSS_PIXFMT_RAW16_OPAQUE",
                        "fps": "DCAM_FPS_2000",
                        "width": 5472,
                        "height": 3648,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "vmem_flag": 31,
                        "buffer_nr": 8
                    }
                ]
            },
            {
                "id": "still_fcali_bin2",
                "shooter_id": "still-yuvraw_zsl",
                "shooter_param": "res=fcali_bin2;normal_cap=offline;",
                "still_process_pipe": [
                    {
                        "id": "main_pipe",
                        "nodes": [
                            {
                                "id": "input",
                                "param": ""
                            }
                        ]
                    },
                    {
                        "id": "aeb_pipe",
                        "nodes": [
                            {
                                "id": "input",
                                "param": ""
                            }
                        ]
                    }
                ],
                "sensor_fps": "DCAM_FPS_2997",
                "filters": [
                    {
                        "type": "dzoom",
                        "id": "dzoom_1",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "disp_eng",
                        "id": "disp_eng_1",
                        "style": "listen",
                        "parameter": "name=wm232;"
                    }
                ],
                "streams": [
                    {
                        "id": "liveview",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_LIVEVIEW",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2997",
                        "width": 1632,
                        "height": 1088,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "buffer_nr": 11,
                        "vmem_flag": 31,
                        "sink_filters": [
                            {
                                "filter_id": "disp_eng_1",
                                "port_index": 0
                            }
                        ]
                    },
                    {
                       "id" : "zsl_raw",
                       "type": "DCAM_STREAM_TYPE_COMMON",
                       "usage": "DCAM_STREAM_USAGE_STILL",
                       "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                       "format": "DUSS_PIXFMT_RAW16_OPAQUE",
                       "fps": "DCAM_FPS_2997",
                       "width": 2736,
                       "height": 1824,
                       "width_alignment": 128,
                       "height_alignment": 1,
                       "buffer_nr": 8
                    },
                    {
                       "id" : "zsl_yuv",
                       "type": "DCAM_STREAM_TYPE_COMMON",
                       "usage": "DCAM_STREAM_USAGE_STILL",
                       "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                       "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                       "fps": "DCAM_FPS_2997",
                       "width": 2736,
                       "height": 1824,
                       "width_alignment": 128,
                       "height_alignment": 1,
                       "buffer_nr": 8
                    },
                    {
                        "id": "still_yuv",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_STILL",
                        "behavior": "DCAM_STREAM_BEHAVIOR_PERREQUEST",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2997",
                        "width": 2736,
                        "height": 1824,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "vmem_flag": 31,
                        "buffer_nr": 3
                    },
                    {
                        "id": "still_raw",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_STILL",
                        "behavior": "DCAM_STREAM_BEHAVIOR_PERREQUEST",
                        "format": "DUSS_PIXFMT_RAW16_OPAQUE",
                        "fps": "DCAM_FPS_2997",
                        "width": 2736,
                        "height": 1824,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "vmem_flag": 31,
                        "buffer_nr": 3
                    }
                ]
            },
            {
                "id": "still_fcali_bin2ob",
                "shooter_id": "still-yuvraw_zsl",
                "shooter_param": "res=fcali_bin2ob;normal_cap=offline;",
                "still_process_pipe": [
                    {
                        "id": "main_pipe",
                        "nodes": [
                            {
                                "id": "input",
                                "param": ""
                            }
                        ]
                    },
                    {
                        "id": "aeb_pipe",
                        "nodes": [
                            {
                                "id": "input",
                                "param": ""
                            }
                        ]
                    }
                ],
                "sensor_fps": "DCAM_FPS_2997",
                "filters": [
                    {
                        "type": "dzoom",
                        "id": "dzoom_1",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "disp_eng",
                        "id": "disp_eng_1",
                        "style": "listen",
                        "parameter": "name=wm232;"
                    }
                ],
                "streams": [
                    {
                        "id": "liveview",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_LIVEVIEW",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2997",
                        "width": 1632,
                        "height": 1088,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "buffer_nr": 11,
                        "vmem_flag": 31,
                        "sink_filters": [
                            {
                                "filter_id": "disp_eng_1",
                                "port_index": 0
                            }
                        ]
                    },
                    {
                       "id" : "zsl_raw",
                       "type": "DCAM_STREAM_TYPE_COMMON",
                       "usage": "DCAM_STREAM_USAGE_STILL",
                       "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                       "format": "DUSS_PIXFMT_RAW16_OPAQUE",
                       "fps": "DCAM_FPS_2997",
                       "width": 2784,
                       "height": 1842,
                       "width_alignment": 128,
                       "height_alignment": 1,
                       "buffer_nr": 8
                    },
                    {
                       "id" : "zsl_yuv",
                       "type": "DCAM_STREAM_TYPE_COMMON",
                       "usage": "DCAM_STREAM_USAGE_STILL",
                       "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                       "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                       "fps": "DCAM_FPS_2997",
                       "width": 2784,
                       "height": 1842,
                       "width_alignment": 128,
                       "height_alignment": 1,
                       "buffer_nr": 8
                    },
                    {
                        "id": "still_yuv",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_STILL",
                        "behavior": "DCAM_STREAM_BEHAVIOR_PERREQUEST",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2997",
                        "width": 2784,
                        "height": 1842,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "vmem_flag": 31,
                        "buffer_nr": 3
                    },
                    {
                        "id": "still_raw",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_STILL",
                        "behavior": "DCAM_STREAM_BEHAVIOR_PERREQUEST",
                        "format": "DUSS_PIXFMT_RAW16_OPAQUE",
                        "fps": "DCAM_FPS_2997",
                        "width": 2784,
                        "height": 1842,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "vmem_flag": 31,
                        "buffer_nr": 3
                    }
                ]
            },

            {
                "id": "still_16x9",
                "shooter_id": "still-general",
                "shooter_param": "res=16x9;normal_cap=offline;",
                "still_raw_process_pipe": [
                    {
                        "id": "raw_process_pipe",
                        "nodes": [
                            {
                                "id": "input",
                                "param": ""
                            },
                            {
                                "id": "ob",
                                "param": "output_buffer_nr=2;dsp_cores=16;outstanding_mask=100663296;"
                            }
                        ]
                    }
                ],
                "still_process_pipe": [
                    {
                        "id": "main_pipe",
                        "nodes": [
                            {
                                "id": "input",
                                "param": ""
                            },
                            {
                                "id": "tino",
                                "param": "output_buffer_nr=1;dsp_cores=16;outstanding_mask=100663296;"
                            }
                        ]
                    },
                    {
                        "id": "aeb_pipe",
                        "nodes": [
                            {
                                "id": "input",
                                "param": ""
                            },
                            {
                                "id": "tino",
                                "param": "output_buffer_nr=1;dsp_cores=16;outstanding_mask=100663296;"
                            }
                        ]
                    }
                ],
                "sensor_fps": "DCAM_FPS_2500",
                "filters": [
                    {
                        "type": "dzoom",
                        "id": "dzoom_1",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "disp_eng",
                        "id": "disp_eng_1",
                        "style": "listen",
                        "parameter": "name=wm232;"
                    }
                ],
                "streams": [
                    {
                        "id": "liveview",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_LIVEVIEW",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2500",
                        "width": 1920,
                        "height": 1080,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "buffer_nr": 10,
                        "vmem_flag": 31,
                        "priority": "high",
                        "sink_filters": [
                            {
                                "filter_id": "disp_eng_1",
                                "port_index": 0
                            }
                        ]
                    },
                    {
                        "id": "still_yuv",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_STILL",
                        "behavior": "DCAM_STREAM_BEHAVIOR_PERREQUEST",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_1500",
                        "width": 5472,
                        "height": 3078,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "vmem_flag": 31,
                        "priority": "high",
                        "buffer_nr": 8
                    },
                    {
                        "id": "still_raw",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_STILL",
                        "behavior": "DCAM_STREAM_BEHAVIOR_PERREQUEST",
                        "format": "DUSS_PIXFMT_RAW16_OPAQUE",
                        "fps": "DCAM_FPS_1500",
                        "width": 5568,
                        "height": 3078,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "vmem_flag": 31,
                        "priority": "high",
                        "buffer_nr": 8
                    },
                    {
                        "id": "navigation",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_VISION",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2500",
                        "width": 1280,
                        "height": 720,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "vmem_flag": 31,
                        "buffer_nr": 10,
                        "sink_filters": [
                            {
                                "filter_id": "dzoom_1",
                                "port_index": 0
                            }
                        ]
                    },
                    {
                        "id": "vision",
                        "type": "DCAM_STREAM_TYPE_FILTER",
                        "usage": "DCAM_STREAM_USAGE_VISION",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2500",
                        "width": 640,
                        "height": 360,
                        "width_alignment": 128,
                        "height_alignment": 480,
                        "vmem_flag": 31,
                        "buffer_nr": 10,
                        "source_filter": {
                            "filter_id": "dzoom_1",
                            "port_index": 0
                        }
                    }
                ]
            },
            {
                "id": "still_fcali_vsubh2",
                "shooter_id": "still-yuvraw_zsl",
                "shooter_param": "res=fcali_vsubh2;normal_cap=offline;",
                "still_process_pipe": [
                    {
                        "id": "main_pipe",
                        "nodes": [
                            {
                                "id": "input",
                                "param": ""
                            }
                        ]
                    },
                    {
                        "id": "aeb_pipe",
                        "nodes": [
                            {
                                "id": "input",
                                "param": ""
                            }
                        ]
                    }
                ],
                "sensor_fps": "DCAM_FPS_2997",
                "filters": [
                    {
                        "type": "dzoom",
                        "id": "dzoom_1",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "disp_eng",
                        "id": "disp_eng_1",
                        "style": "listen",
                        "parameter": "name=wm232;"
                    }
                ],
                "streams": [
                    {
                        "id": "liveview",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_LIVEVIEW",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2997",
                        "width": 1920,
                        "height": 1080,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "buffer_nr": 11,
                        "vmem_flag": 31,
                        "sink_filters": [
                            {
                                "filter_id": "disp_eng_1",
                                "port_index": 0
                            }
                        ]
                    },
                    {
                       "id" : "zsl_raw",
                       "type": "DCAM_STREAM_TYPE_COMMON",
                       "usage": "DCAM_STREAM_USAGE_STILL",
                       "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                       "format": "DUSS_PIXFMT_RAW16_OPAQUE",
                       "fps": "DCAM_FPS_2997",
                       "width": 1920,
                       "height": 1080,
                       "width_alignment": 128,
                       "height_alignment": 1,
                       "buffer_nr": 10
                    },
                    {
                       "id" : "zsl_yuv",
                       "type": "DCAM_STREAM_TYPE_COMMON",
                       "usage": "DCAM_STREAM_USAGE_STILL",
                       "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                       "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                       "fps": "DCAM_FPS_2997",
                       "width": 1920,
                       "height": 1080,
                       "width_alignment": 128,
                       "height_alignment": 1,
                       "buffer_nr": 10
                    },
                    {
                        "id": "still_yuv",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_STILL",
                        "behavior": "DCAM_STREAM_BEHAVIOR_PERREQUEST",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2997",
                        "width": 1920,
                        "height": 1080,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "vmem_flag": 31,
                        "buffer_nr": 8
                    },
                    {
                        "id": "still_raw",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_STILL",
                        "behavior": "DCAM_STREAM_BEHAVIOR_PERREQUEST",
                        "format": "DUSS_PIXFMT_RAW16_OPAQUE",
                        "fps": "DCAM_FPS_2997",
                        "width": 1920,
                        "height": 1080,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "vmem_flag": 31,
                        "buffer_nr": 8
                    }
                ]
            },
            {
                "id": "still_16x9_middle",
                "shooter_id": "still-general",
                "shooter_param": "res=16x9_middle;normal_cap=offline;",
                "still_process_pipe": [
                    {
                        "id": "main_pipe",
                        "nodes": [
                            {
                                "id": "input",
                                "param": ""
                            },
                            {
                                "id": "tino",
                                "param": "output_buffer_nr=1;dsp_cores=16;outstanding_mask=100663296;"
                            }
                        ]
                    },
                    {
                        "id": "aeb_pipe",
                        "nodes": [
                            {
                                "id": "input",
                                "param": ""
                            },
                            {
                                "id": "tino",
                                "param": "output_buffer_nr=1;dsp_cores=16;outstanding_mask=100663296;"
                            }
                        ]
                    }
                ],
                "sensor_fps": "DCAM_FPS_5994",
                "filters": [
                    {
                        "type": "dzoom",
                        "id": "dzoom_1",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "disp_eng",
                        "id": "disp_eng_1",
                        "style": "listen",
                        "parameter": "name=wm232_online;"
                    }
                ],
                "streams": [
                    {
                        "id": "liveview",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_LIVEVIEW",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP422_YUV",
                        "fps": "DCAM_FPS_5994",
                        "width": 1920,
                        "height": 1080,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "buffer_nr": 10,
                        "vmem_flag": 31,
                        "sink_filters": [
                            {
                                "filter_id": "disp_eng_1",
                                "port_index": 0
                            }
                        ]
                    },
                    {
                        "id": "still_yuv",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_STILL",
                        "behavior": "DCAM_STREAM_BEHAVIOR_PERREQUEST",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2997",
                        "width": 3840,
                        "height": 2160,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "vmem_flag": 31,
                        "buffer_nr": 8
                    },
                    {
                        "id": "still_raw",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_STILL",
                        "behavior": "DCAM_STREAM_BEHAVIOR_PERREQUEST",
                        "format": "DUSS_PIXFMT_RAW16_OPAQUE",
                        "fps": "DCAM_FPS_2997",
                        "width": 3840,
                        "height": 2160,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "vmem_flag": 31,
                        "buffer_nr": 8
                    },
                    {
                        "id": "navigation",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_VISION",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2997",
                        "width": 1280,
                        "height": 720,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "vmem_flag": 31,
                        "buffer_nr": 10,
                        "sink_filters": [
                            {
                                "filter_id": "dzoom_1",
                                "port_index": 0
                            }
                        ]
                    },
                    {
                        "id": "vision",
                        "type": "DCAM_STREAM_TYPE_FILTER",
                        "usage": "DCAM_STREAM_USAGE_VISION",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2997",
                        "width": 640,
                        "height": 360,
                        "width_alignment": 128,
                        "height_alignment": 480,
                        "vmem_flag": 31,
                        "buffer_nr": 10,
                        "source_filter": {
                            "filter_id": "dzoom_1",
                            "port_index": 0
                        }
                    }
                ]
            },
            {
                "id": "still_16x9_scap",
                "shooter_id": "still-general",
                "shooter_param": "res=16x9_scap",
                "still_process_pipe": [
                    {
                        "id": "main_pipe",
                        "nodes": [
                            {
                                "id": "input",
                                "param": ""
                            },
                            {
                                "id": "llf",
                                "param": "output_buffer_nr=1;dsp_cores=30;outstanding_mask=102261126;out_format=DUSS_PIXFMT_YUV8_SP420_YUV;"
                            },
                            {
                                "id": "tino",
                                "param": "output_buffer_nr=1;out_format=DUSS_PIXFMT_YUV8_SP420_YUV;dsp_cores=30;outstanding_mask=102261126;"
                            }
                        ]
                    },
                    {
                        "id": "hdr_pipe",
                        "nodes": [
                            {
                                "id": "input",
                                "param": ""
                            }
                        ]
                    }
                ],
                "sensor_fps": "DCAM_FPS_2500",
                "filters": [
                    {
                        "type": "dzoom",
                        "id": "dzoom_1",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "disp_eng",
                        "id": "disp_eng_1",
                        "style": "listen",
                        "parameter": "name=wm232;"
                    }
                ],
                "streams": [
                    {
                        "id": "liveview",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_LIVEVIEW",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2500",
                        "width": 1920,
                        "height": 1080,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "buffer_nr": 10,
                        "vmem_flag": 31,
                        "priority": "high",
                        "sink_filters": [
                            {
                                "filter_id": "disp_eng_1",
                                "port_index": 0
                            }
                        ]
                    },
                    {
                        "id": "still_yuv",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_STILL",
                        "behavior": "DCAM_STREAM_BEHAVIOR_PERREQUEST",
                        "format": "DUSS_PIXFMT_YUV10_SP420_YUV",
                        "fps": "DCAM_FPS_2400",
                        "width": 5472,
                        "height": 3078,
                        "width_alignment": 128,
                        "height_alignment": 32,
                        "vmem_flag": 31,
                        "priority": "high",
                        "buffer_nr": 4
                    },
                    {
                        "id": "still_raw",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_STILL",
                        "behavior": "DCAM_STREAM_BEHAVIOR_PERREQUEST",
                        "format": "DUSS_PIXFMT_RAW16_OPAQUE",
                        "fps": "DCAM_FPS_2500",
                        "width": 5568,
                        "height": 3078,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "vmem_flag": 31,
                        "buffer_nr": 8
                    },
                    {
                        "id": "navigation",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_VISION",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2500",
                        "width": 1280,
                        "height": 720,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "vmem_flag": 31,
                        "buffer_nr": 10,
                        "sink_filters": [
                            {
                                "filter_id": "dzoom_1",
                                "port_index": 0
                            }
                        ]
                    },
                    {
                        "id": "vision",
                        "type": "DCAM_STREAM_TYPE_FILTER",
                        "usage": "DCAM_STREAM_USAGE_VISION",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2500",
                        "width": 640,
                        "height": 360,
                        "width_alignment": 128,
                        "height_alignment": 480,
                        "vmem_flag": 31,
                        "buffer_nr": 10,
                        "source_filter": {
                            "filter_id": "dzoom_1",
                            "port_index": 0
                        }
                    }
                ]
            },
            {
                "id": "still_3x2_scap",
                "shooter_id": "still-general",
                "shooter_param": "res=3x2_scap",
                "still_process_pipe": [
                    {
                        "id": "main_pipe",
                        "nodes": [
                            {
                                "id": "input",
                                "param": ""
                          },
                          {
                            "id": "llf",
                            "param": "output_buffer_nr=1;dsp_cores=30;outstanding_mask=102261126;out_format=DUSS_PIXFMT_YUV8_SP420_YUV;"
                          },
                          {
                            "id": "tino",
                            "param": "output_buffer_nr=1;out_format=DUSS_PIXFMT_YUV8_SP420_YUV;dsp_cores=30;outstanding_mask=102261126;"
                          }
                        ]
                    },
                    {
                        "id": "hdr_pipe",
                        "nodes": [
                            {
                                "id": "input",
                                "param": ""
                            }
                        ]
                    }
                ],
                "sensor_fps": "DCAM_FPS_2500",
                "filters": [
                    {
                        "type": "dzoom",
                        "id": "dzoom_1",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "disp_eng",
                        "id": "disp_eng_1",
                        "style": "listen",
                        "parameter": "name=wm232;"
                    }
                ],
                "streams": [
                    {
                        "id": "liveview",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_LIVEVIEW",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2500",
                        "width": 1632,
                        "height": 1088,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "buffer_nr": 10,
                        "vmem_flag": 31,
                        "priority": "high",
                        "sink_filters": [
                            {
                                "filter_id": "disp_eng_1",
                                "port_index": 0
                            }
                        ]
                    },
                    {
                        "id": "still_yuv",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_STILL",
                        "behavior": "DCAM_STREAM_BEHAVIOR_PERREQUEST",
                        "format": "DUSS_PIXFMT_YUV10_SP420_YUV",
                        "fps": "DCAM_FPS_2400",
                        "width": 5472,
                        "height": 3648,
                        "width_alignment": 128,
                        "height_alignment": 32,
                        "vmem_flag": 31,
                        "priority": "high",
                        "buffer_nr": 4
                    },
                    {
                        "id": "still_raw",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_STILL",
                        "behavior": "DCAM_STREAM_BEHAVIOR_PERREQUEST",
                        "format": "DUSS_PIXFMT_RAW16_OPAQUE",
                        "fps": "DCAM_FPS_2500",
                        "width": 5568,
                        "height": 3648,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "vmem_flag": 31,
                        "buffer_nr": 8
                    },
                    {
                        "id": "navigation",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_VISION",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2500",
                        "width": 1280,
                        "height": 852,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "vmem_flag": 31,
                        "buffer_nr": 10,
                        "sink_filters": [
                            {
                                "filter_id": "dzoom_1",
                                "port_index": 0
                            }
                        ]
                    },
                    {
                        "id": "vision",
                        "type": "DCAM_STREAM_TYPE_FILTER",
                        "usage": "DCAM_STREAM_USAGE_VISION",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2500",
                        "width": 640,
                        "height": 426,
                        "width_alignment": 128,
                        "height_alignment": 480,
                        "vmem_flag": 31,
                        "buffer_nr": 10,
                        "source_filter": {
                            "filter_id": "dzoom_1",
                            "port_index": 0
                        }
                    }
                ]
            },
            {
                "id": "still_16x9_zsl_sdr",
                "shooter_id": "still-raw_zsl",
                "shooter_param": "res=16x9_zsl_sdr",
                "still_process_pipe": [
                    {
                        "id": "main_pipe",
                        "nodes": [
                            {
                                "id": "input",
                                "param": ""
                            },
                            {
                                "id": "llf",
                                "param": "output_buffer_nr=1;dsp_cores=30;outstanding_mask=102261126;out_format=DUSS_PIXFMT_YUV8_SP420_YUV;"
                            },
                            {
                                "id": "tino",
                                "param": "output_buffer_nr=1;out_format=DUSS_PIXFMT_YUV8_SP420_YUV;dsp_cores=30;outstanding_mask=102261126;"
                            }
                        ]
                    },
                    {
                        "id": "hdr_pipe",
                        "nodes": [
                            {
                                "id": "input",
                                "param": ""
                            }
                        ]
                    }
                ],
                "sensor_fps": "DCAM_FPS_2500",
                "filters": [
                    {
                        "type": "dzoom",
                        "id": "dzoom_1",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "disp_eng",
                        "id": "disp_eng_1",
                        "style": "listen",
                        "parameter": "name=wm232;"
                    }
                ],
                "streams": [
                    {
                        "id": "liveview",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_LIVEVIEW",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2500",
                        "width": 1920,
                        "height": 1080,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "buffer_nr": 10,
                        "vmem_flag": 31,
                        "priority": "high",
                        "sink_filters": [
                            {
                                "filter_id": "disp_eng_1",
                                "port_index": 0
                            }
                        ]
                    },
                    {
                        "id": "still_yuv",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_STILL",
                        "behavior": "DCAM_STREAM_BEHAVIOR_PERREQUEST",
                        "format": "DUSS_PIXFMT_YUV10_SP420_YUV",
                        "fps": "DCAM_FPS_2500",
                        "width": 5472,
                        "height": 3078,
                        "width_alignment": 128,
                        "height_alignment": 32,
                        "vmem_flag": 31,
                        "priority": "high",
                        "buffer_nr": 4
                    },
                    {
                        "id": "zsl_raw",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_STILL",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_RAW16_OPAQUE",
                        "fps": "DCAM_FPS_2500",
                        "width": 5568,
                        "height": 3078,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "vmem_flag": 31,
                        "buffer_nr": 8
                    },
                    {
                        "id": "navigation",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_VISION",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2500",
                        "width": 1280,
                        "height": 720,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "vmem_flag": 31,
                        "buffer_nr": 10,
                        "sink_filters": [
                            {
                                "filter_id": "dzoom_1",
                                "port_index": 0
                            }
                        ]
                    },
                    {
                        "id": "vision",
                        "type": "DCAM_STREAM_TYPE_FILTER",
                        "usage": "DCAM_STREAM_USAGE_VISION",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2500",
                        "width": 640,
                        "height": 360,
                        "width_alignment": 128,
                        "height_alignment": 480,
                        "vmem_flag": 31,
                        "buffer_nr": 10,
                        "source_filter": {
                            "filter_id": "dzoom_1",
                            "port_index": 0
                        }
                    }
                ]
            },
            {
                "id": "still_3x2_zsl_sdr",
                "shooter_id": "still-raw_zsl",
                "shooter_param": "res=3x2_zsl_sdr",
                "still_process_pipe": [
                    {
                        "id": "main_pipe",
                        "nodes": [
                            {
                                "id": "input",
                                "param": ""
                          },
                          {
                            "id": "llf",
                            "param": "output_buffer_nr=1;dsp_cores=30;outstanding_mask=102261126;out_format=DUSS_PIXFMT_YUV8_SP420_YUV;"
                          },
                          {
                            "id": "tino",
                            "param": "output_buffer_nr=1;out_format=DUSS_PIXFMT_YUV8_SP420_YUV;dsp_cores=30;outstanding_mask=102261126;"
                          }
                        ]
                    },
                    {
                        "id": "hdr_pipe",
                        "nodes": [
                            {
                                "id": "input",
                                "param": ""
                            }
                        ]
                    }
                ],
                "sensor_fps": "DCAM_FPS_2500",
                "filters": [
                    {
                        "type": "dzoom",
                        "id": "dzoom_1",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "disp_eng",
                        "id": "disp_eng_1",
                        "style": "listen",
                        "parameter": "name=wm232;"
                    }
                ],
                "streams": [
                    {
                        "id": "liveview",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_LIVEVIEW",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2500",
                        "width": 1632,
                        "height": 1088,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "buffer_nr": 10,
                        "vmem_flag": 31,
                        "priority": "high",
                        "sink_filters": [
                            {
                                "filter_id": "disp_eng_1",
                                "port_index": 0
                            }
                        ]
                    },
                    {
                        "id": "still_yuv",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_STILL",
                        "behavior": "DCAM_STREAM_BEHAVIOR_PERREQUEST",
                        "format": "DUSS_PIXFMT_YUV10_SP420_YUV",
                        "fps": "DCAM_FPS_2500",
                        "width": 5472,
                        "height": 3648,
                        "width_alignment": 128,
                        "height_alignment": 32,
                        "vmem_flag": 31,
                        "priority": "high",
                        "buffer_nr": 4
                    },
                    {
                        "id": "zsl_raw",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_STILL",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_RAW16_OPAQUE",
                        "fps": "DCAM_FPS_2500",
                        "width": 5568,
                        "height": 3648,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "vmem_flag": 31,
                        "buffer_nr": 8
                    },
                    {
                        "id": "navigation",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_VISION",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2500",
                        "width": 1280,
                        "height": 852,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "vmem_flag": 31,
                        "buffer_nr": 10,
                        "sink_filters": [
                            {
                                "filter_id": "dzoom_1",
                                "port_index": 0
                            }
                        ]
                    },
                    {
                        "id": "vision",
                        "type": "DCAM_STREAM_TYPE_FILTER",
                        "usage": "DCAM_STREAM_USAGE_VISION",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2500",
                        "width": 640,
                        "height": 426,
                        "width_alignment": 128,
                        "height_alignment": 480,
                        "vmem_flag": 31,
                        "buffer_nr": 10,
                        "source_filter": {
                            "filter_id": "dzoom_1",
                            "port_index": 0
                        }
                    }
                ]
            },
            {
                "id": "video_5472x3078_2997",
                "shooter_id": "video-single",
                "sensor_fps": "DCAM_FPS_2997",
                "filters": [
                    {
                        "type": "dzoom",
                        "id": "dzoom_1",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "disp_eng",
                        "id": "disp_eng_1",
                        "style": "listen",
                        "parameter": "name=wm232;"
                    }
                ],
                "streams": [
                    {
                        "id": "liveview",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_LIVEVIEW",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2997",
                        "width": 1920,
                        "height": 1080,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "buffer_nr": 10,
                        "vmem_flag": 31,
                        "priority": "high",
                        "sink_filters": [
                            {
                                "filter_id": "disp_eng_1",
                                "port_index": 0
                            }
                        ]
                    },
                    {
                        "id": "navigation",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_VISION",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "flag": [
                            "DCAM_STREAM_FLAG_ZERO_FRAME_BUFFER_ON_INIT"
                        ],
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2997",
                        "width": 1280,
                        "height": 720,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "buffer_nr": 10,
                        "priority": "high",
                        "sink_filters": [
                            {
                                "filter_id": "dzoom_1",
                                "port_index": 0
                            }
                        ]
                    },
                    {
                        "id": "vision",
                        "type": "DCAM_STREAM_TYPE_FILTER",
                        "usage": "DCAM_STREAM_USAGE_VISION",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2997",
                        "width": 640,
                        "height": 360,
                        "width_alignment": 128,
                        "height_alignment": 480,
                        "vmem_flag": 31,
                        "buffer_nr": 10,
                        "priority": "high",
                        "source_filter": {
                            "filter_id": "dzoom_1",
                            "port_index": 0
                        }
                    },
                    {
                        "id": "video",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_VIDEO",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "flag": [
                            "DCAM_STREAM_FLAG_ON_DEMAND"
                        ],
                        "fps": "DCAM_FPS_2997",
                        "width": 5472,
                        "height": 3078,
                        "width_alignment": 128,
                        "height_alignment": 64,
                        "buffer_nr": 11,
                        "priority": "higher"
                    },
                    {
                        "id": "raw_dump",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_STILL",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_RAW16_OPAQUE",
                        "flag": [
                            "DCAM_STREAM_FLAG_ON_DEMAND"
                        ],
                        "fps": "DCAM_FPS_2997",
                        "width": 5472,
                        "height": 3078,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "buffer_nr": 2
                    }
                ]
            },
            {
                "id": "video_5472x3078_2997_10bit",
                "shooter_id": "video-single",
                "sensor_fps": "DCAM_FPS_2997",
                "filters": [
                    {
                        "type": "dzoom",
                        "id": "dzoom_1",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "disp_eng",
                        "id": "disp_eng_1",
                        "style": "listen",
                        "parameter": "name=wm232;"
                    }
                ],
                "streams": [
                    {
                        "id": "liveview",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_LIVEVIEW",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2997",
                        "width": 1920,
                        "height": 1080,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "buffer_nr": 10,
                        "vmem_flag": 31,
                        "sink_filters": [
                            {
                                "filter_id": "disp_eng_1",
                                "port_index": 0
                            }
                        ]
                    },
                    {
                        "id": "navigation",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_VISION",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "flag": [
                            "DCAM_STREAM_FLAG_ZERO_FRAME_BUFFER_ON_INIT"
                        ],
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2997",
                        "width": 1280,
                        "height": 720,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "buffer_nr": 10,
                        "priority": "high",
                        "sink_filters": [
                        {
                            "filter_id": "dzoom_1",
                            "port_index": 0
                        }
                      ]
                    },
                    {
                        "id": "vision",
                        "type": "DCAM_STREAM_TYPE_FILTER",
                        "usage": "DCAM_STREAM_USAGE_VISION",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2997",
                        "width": 640,
                        "height": 360,
                        "width_alignment": 128,
                        "height_alignment": 480,
                        "vmem_flag": 31,
                        "buffer_nr": 10,
                        "priority": "high",
                        "source_filter": {
                            "filter_id": "dzoom_1",
                            "port_index": 0
                        }
                    },
                    {
                        "id": "video",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_VIDEO",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV10_SP420_YUV",
                        "flag": [
                            "DCAM_STREAM_FLAG_ON_DEMAND"
                        ],
                        "fps": "DCAM_FPS_2997",
                        "width": 5472,
                        "height": 3078,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "buffer_nr": 5,
                        "priority": "higher"
                    },
                    {
                        "id": "raw_dump",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_STILL",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_RAW16_OPAQUE",
                        "flag": [
                            "DCAM_STREAM_FLAG_ON_DEMAND"
                        ],
                        "fps": "DCAM_FPS_2997",
                        "width": 5472,
                        "height": 3078,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "buffer_nr": 2

                    }
                ]
            },
            {
                "id": "video_5472x3078_2397",
                "shooter_id": "video-single",
                "sensor_fps": "DCAM_FPS_2397",
                "filters": [
                    {
                        "type": "dzoom",
                        "id": "dzoom_1",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "disp_eng",
                        "id": "disp_eng_1",
                        "style": "listen",
                        "parameter": "name=wm232;"
                    }
                ],
                "streams": [
                    {
                        "id": "liveview",
                        "copy_from": "video_5472x3078_2997/liveview",
                        "vmem_flag": 31,
                        "fps": "DCAM_FPS_2397"
                    },
                    {
                        "id": "navigation",
                        "copy_from": "video_5472x3078_2997/navigation",
                        "fps": "DCAM_FPS_2397"
                    },
                    {
                        "id": "vision",
                        "copy_from": "video_5472x3078_2997/vision",
                        "fps": "DCAM_FPS_2397"
                    },
                    {
                        "id": "video",
                        "copy_from": "video_5472x3078_2997/video",
                        "fps": "DCAM_FPS_2397"
                    },
                    {
                        "id": "raw_dump",
                        "copy_from": "video_5472x3078_2997/raw_dump",
                        "fps": "DCAM_FPS_2397"
                    }
                ]
            },
            {
                "id": "video_5472x3078_2397_10bit",
                "shooter_id": "video-single",
                "sensor_fps": "DCAM_FPS_2397",
                "filters": [
                    {
                        "type": "dzoom",
                        "id": "dzoom_1",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "disp_eng",
                        "id": "disp_eng_1",
                        "style": "listen",
                        "parameter": "name=wm232;"
                    }
                ],
                "streams": [
                    {
                        "id": "liveview",
                        "copy_from": "video_5472x3078_2997_10bit/liveview",
                        "vmem_flag": 31,
                        "fps": "DCAM_FPS_2397"
                    },
                    {
                        "id": "navigation",
                        "copy_from": "video_5472x3078_2997_10bit/navigation",
                        "fps": "DCAM_FPS_2397"
                    },
                    {
                        "id": "vision",
                        "copy_from": "video_5472x3078_2997_10bit/vision",
                        "fps": "DCAM_FPS_2397"
                    },
                    {
                        "id": "video",
                        "copy_from": "video_5472x3078_2997_10bit/video",
                        "fps": "DCAM_FPS_2397"
                    },
                    {
                        "id": "raw_dump",
                        "copy_from": "video_5472x3078_2997_10bit/raw_dump",
                        "fps": "DCAM_FPS_2397"
                    }
                ]
            },
            {
                "id": "video_5472x3078_2500",
                "shooter_id": "video-single",
                "sensor_fps": "DCAM_FPS_2500",
                "filters": [
                    {
                        "type": "dzoom",
                        "id": "dzoom_1",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "disp_eng",
                        "id": "disp_eng_1",
                        "style": "listen",
                        "parameter": "name=wm232;"
                    }
                ],
                "streams": [
                    {
                        "id": "liveview",
                        "copy_from": "video_5472x3078_2997/liveview",
                        "vmem_flag": 31,
                        "fps": "DCAM_FPS_2500"
                    },
                    {
                        "id": "navigation",
                        "copy_from": "video_5472x3078_2997/navigation",
                        "fps": "DCAM_FPS_2500"
                    },
                    {
                        "id": "vision",
                        "copy_from": "video_5472x3078_2997/vision",
                        "fps": "DCAM_FPS_2500"
                    },
                    {
                        "id": "video",
                        "copy_from": "video_5472x3078_2997/video",
                        "fps": "DCAM_FPS_2500"
                    },
                    {
                        "id": "raw_dump",
                        "copy_from": "video_5472x3078_2997/raw_dump",
                        "fps": "DCAM_FPS_2500"
                    }
                ]
            },
            {
                "id": "video_5472x3078_2500_10bit",
                "shooter_id": "video-single",
                "sensor_fps": "DCAM_FPS_2500",
                "filters": [
                    {
                        "type": "dzoom",
                        "id": "dzoom_1",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "disp_eng",
                        "id": "disp_eng_1",
                        "style": "listen",
                        "parameter": "name=wm232;"
                    }
                ],
                "streams": [
                    {
                        "id": "liveview",
                        "copy_from": "video_5472x3078_2997_10bit/liveview",
                        "vmem_flag": 31,
                        "fps": "DCAM_FPS_2500"
                    },
                    {
                        "id": "navigation",
                        "copy_from": "video_5472x3078_2997_10bit/navigation",
                        "fps": "DCAM_FPS_2500"
                    },
                    {
                        "id": "vision",
                        "copy_from": "video_5472x3078_2997_10bit/vision",
                        "fps": "DCAM_FPS_2500"
                    },
                    {
                        "id": "video",
                        "copy_from": "video_5472x3078_2997_10bit/video",
                        "fps": "DCAM_FPS_2500"
                    },
                    {
                        "id": "raw_dump",
                        "copy_from": "video_5472x3078_2997_10bit/raw_dump",
                        "fps": "DCAM_FPS_2500"
                    }
                ]
            },
            {
                "id": "video_3840x2160_5994",
                "shooter_id": "video-single",
                "sensor_fps": "DCAM_FPS_5994",
                "filters": [
                    {
                        "type": "dzoom",
                        "id": "dzoom_1",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "disp_eng",
                        "id": "disp_eng_1",
                        "style": "listen",
                        "parameter": "name=wm232;"
                    }
                ],
                "streams": [
                    {
                        "id": "liveview",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_LIVEVIEW",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2997",
                        "width": 1920,
                        "height": 1080,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "buffer_nr": 10,
                        "vmem_flag": 31,
                        "priority": "high",
                        "sink_filters": [
                            {
                                "filter_id": "disp_eng_1",
                                "port_index": 0
                            }
                        ]
                    },
                    {
                        "id": "navigation",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_VISION",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "flag": [
                            "DCAM_STREAM_FLAG_ZERO_FRAME_BUFFER_ON_INIT"
                        ],
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2997",
                        "width": 1280,
                        "height": 720,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "buffer_nr": 10,
                        "priority": "high",
                        "sink_filters": [
                            {
                                "filter_id": "dzoom_1",
                                "port_index": 0
                            }
                       ]
                    },
                    {
                        "id": "vision",
                        "type": "DCAM_STREAM_TYPE_FILTER",
                        "usage": "DCAM_STREAM_USAGE_VISION",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2997",
                        "width": 640,
                        "height": 360,
                        "width_alignment": 128,
                        "height_alignment": 480,
                        "vmem_flag": 31,
                        "buffer_nr": 10,
                        "priority": "high",
                        "source_filter": {
                            "filter_id": "dzoom_1",
                            "port_index": 0
                        }
                    },
                    {
                        "id": "video",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_VIDEO",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "flag": [
                            "DCAM_STREAM_FLAG_ON_DEMAND"
                        ],
                        "fps": "DCAM_FPS_5994",
                        "width": 3840,
                        "height": 2160,
                        "width_alignment": 128,
                        "height_alignment": 64,
                        "buffer_nr": 16,
                        "priority": "higher"
                    },
                    {
                        "id": "raw_dump",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_STILL",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_RAW16_OPAQUE",
                        "flag": [
                            "DCAM_STREAM_FLAG_ON_DEMAND"
                        ],
                        "fps": "DCAM_FPS_5994",
                        "width": 3840,
                        "height": 2160,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "buffer_nr": 2
                    }
                ]
            },
            {
                "id": "video_3840x2160_5994_10bit",
                "shooter_id": "video-single",
                "sensor_fps": "DCAM_FPS_5994",
                "filters": [
                    {
                        "type": "dzoom",
                        "id": "dzoom_1",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "disp_eng",
                        "id": "disp_eng_1",
                        "style": "listen",
                        "parameter": "name=wm232;"
                    }
                ],
                "streams": [
                    {
                        "id": "liveview",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_LIVEVIEW",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2997",
                        "width": 1920,
                        "height": 1080,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "buffer_nr": 11,
                        "vmem_flag": 31,
                        "sink_filters": [
                            {
                                "filter_id": "disp_eng_1",
                                "port_index": 0
                            }
                        ]
                    },
                    {
                        "id": "navigation",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_VISION",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "flag": [
                            "DCAM_STREAM_FLAG_ZERO_FRAME_BUFFER_ON_INIT"
                        ],
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2997",
                        "width": 1280,
                        "height": 720,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "buffer_nr": 10,
                        "priority": "high",
                        "sink_filters": [
                            {
                                "filter_id": "dzoom_1",
                                "port_index": 0
                            }
                        ]
                    },
                    {
                        "id": "vision",
                        "type": "DCAM_STREAM_TYPE_FILTER",
                        "usage": "DCAM_STREAM_USAGE_VISION",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2997",
                        "width": 640,
                        "height": 360,
                        "width_alignment": 128,
                        "height_alignment": 480,
                        "vmem_flag": 31,
                        "buffer_nr": 10,
                        "priority": "high",
                        "source_filter": {
                            "filter_id": "dzoom_1",
                            "port_index": 0
                        }
                    },
                    {
                        "id": "video",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_VIDEO",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV10_SP420_YUV",
                        "flag": [
                            "DCAM_STREAM_FLAG_ON_DEMAND"
                        ],
                        "fps": "DCAM_FPS_5994",
                        "width": 3840,
                        "height": 2160,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "buffer_nr": 16,
                        "priority": "higher"
                    },
                    {
                        "id": "raw_dump",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_STILL",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_RAW16_OPAQUE",
                        "flag": [
                            "DCAM_STREAM_FLAG_ON_DEMAND"
                        ],
                        "fps": "DCAM_FPS_5994",
                        "width": 3840,
                        "height": 2160,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "buffer_nr": 2
                    }
                ]
            },
            {
                "id": "video_3840x2160_4795",
                "shooter_id": "video-single",
                "sensor_fps": "DCAM_FPS_4795",
                "filters": [
                    {
                        "type": "dzoom",
                        "id": "dzoom_1",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "disp_eng",
                        "id": "disp_eng_1",
                        "style": "listen",
                        "parameter": "name=wm232;"
                    }
                ],
                "streams": [
                    {
                        "id": "liveview",
                        "copy_from": "video_3840x2160_5994/liveview",
                        "vmem_flag": 31,
                        "fps": "DCAM_FPS_2397"
                    },
                    {
                        "id": "navigation",
                        "copy_from": "video_3840x2160_5994/navigation",
                        "fps": "DCAM_FPS_2397"
                    },
                    {
                        "id": "vision",
                        "copy_from": "video_3840x2160_5994/vision",
                        "fps": "DCAM_FPS_2397"
                    },
                    {
                        "id": "video",
                        "copy_from": "video_3840x2160_5994/video",
                        "fps": "DCAM_FPS_4795"
                    },
                    {
                        "id": "raw_dump",
                        "copy_from": "video_3840x2160_5994/raw_dump",
                        "fps": "DCAM_FPS_4795"
                    }
                ]
            },
            {
                "id": "video_3840x2160_4795_10bit",
                "shooter_id": "video-single",
                "sensor_fps": "DCAM_FPS_4795",
                "filters": [
                    {
                        "type": "dzoom",
                        "id": "dzoom_1",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "disp_eng",
                        "id": "disp_eng_1",
                        "style": "listen",
                        "parameter": "name=wm232;"
                    }
                ],
                "streams": [
                    {
                        "id": "liveview",
                        "copy_from": "video_3840x2160_5994_10bit/liveview",
                        "vmem_flag": 31,
                        "fps": "DCAM_FPS_2397"
                    },
                    {
                        "id": "navigation",
                        "copy_from": "video_3840x2160_5994_10bit/navigation",
                        "fps": "DCAM_FPS_2397"
                    },
                    {
                        "id": "vision",
                        "copy_from": "video_3840x2160_5994_10bit/vision",
                        "fps": "DCAM_FPS_2397"
                    },
                    {
                        "id": "video",
                        "copy_from": "video_3840x2160_5994_10bit/video",
                        "fps": "DCAM_FPS_4795"
                    },
                    {
                        "id": "raw_dump",
                        "copy_from": "video_3840x2160_5994_10bit/raw_dump",
                        "fps": "DCAM_FPS_4795"
                    }
                ]
            },
            {
                "id": "video_3840x2160_5000",
                "shooter_id": "video-single",
                "sensor_fps": "DCAM_FPS_5000",
                "filters": [
                    {
                        "type": "dzoom",
                        "id": "dzoom_1",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "disp_eng",
                        "id": "disp_eng_1",
                        "style": "listen",
                        "parameter": "name=wm232;"
                    }
                ],
                "streams": [
                    {
                        "id": "liveview",
                        "copy_from": "video_3840x2160_5994/liveview",
                        "vmem_flag": 31,
                        "fps": "DCAM_FPS_2500"
                    },
                    {
                        "id": "navigation",
                        "copy_from": "video_3840x2160_5994/navigation",
                        "fps": "DCAM_FPS_2500"
                    },
                    {
                        "id": "vision",
                        "copy_from": "video_3840x2160_5994/vision",
                        "fps": "DCAM_FPS_2500"
                    },
                    {
                        "id": "video",
                        "copy_from": "video_3840x2160_5994/video",
                        "fps": "DCAM_FPS_5000"
                    },
                    {
                        "id": "raw_dump",
                        "copy_from": "video_3840x2160_5994/raw_dump",
                        "fps": "DCAM_FPS_5000"
                    }
                ]
            },
            {
                "id": "video_3840x2160_5000_10bit",
                "shooter_id": "video-single",
                "sensor_fps": "DCAM_FPS_5000",
                "filters": [
                    {
                        "type": "dzoom",
                        "id": "dzoom_1",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "disp_eng",
                        "id": "disp_eng_1",
                        "style": "listen",
                        "parameter": "name=wm232;"
                    }
                ],
                "streams": [
                    {
                        "id": "liveview",
                        "copy_from": "video_3840x2160_5994_10bit/liveview",
                        "vmem_flag": 31,
                        "fps": "DCAM_FPS_2500"
                    },
                    {
                        "id": "navigation",
                        "copy_from": "video_3840x2160_5994_10bit/navigation",
                        "fps": "DCAM_FPS_2500"
                    },
                    {
                        "id": "vision",
                        "copy_from": "video_3840x2160_5994_10bit/vision",
                        "fps": "DCAM_FPS_2500"
                    },
                    {
                        "id": "video",
                        "copy_from": "video_3840x2160_5994_10bit/video",
                        "fps": "DCAM_FPS_5000"
                    },
                    {
                        "id": "raw_dump",
                        "copy_from": "video_3840x2160_5994_10bit/raw_dump",
                        "fps": "DCAM_FPS_5000"
                    }
                ]
            },
            {
                "id": "video_3840x2160_2997",
                "shooter_id": "video-single",
                "sensor_fps": "DCAM_FPS_2997",
                "digital_zoom_param": "support_dzoom=1;max_dzoom_ratio=42800;max_crop_ratio=14250;",
                "filters": [
                     {
                        "type": "dewarp-pro",
                        "id": "dewarp_1",
                        "style": "push",
                        "parameter": "dynamic_calc=true;supported_output_port=2;distortion_correction=false;"
                    },
                    {
                        "type": "dzoom",
                        "id": "dzoom_1",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "dzoom",
                        "id": "dzoom_2",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "disp_eng",
                        "id": "disp_eng_1",
                        "style": "listen",
                        "parameter": "name=wm232;"
                    }
                ],
                "streams": [
                    {
                        "id": "yuv_piv",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_VIDEO",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2997",
                        "width": 5472,
                        "height": 3078,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "buffer_nr": 6,
                        "priority": "high",
                        "sink_filters": [
                            {
                                "filter_id": "dewarp_1",
                                "port_index": 0
                            }
                        ]
                    },
                    {
                        "id": "liveview",
                        "type": "DCAM_STREAM_TYPE_FILTER",
                        "usage": "DCAM_STREAM_USAGE_LIVEVIEW",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2997",
                        "width": 1920,
                        "height": 1080,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "buffer_nr": 10,
                        "vmem_flag": 31,
                        "priority": "high",
                        "sink_filters": [
                            {
                                "filter_id": "dzoom_1",
                                "port_index": 0
                            },
                            {
                                "filter_id": "disp_eng_1",
                                "port_index": 0
                            }
                        ],
                        "source_filter": {
                            "filter_id": "dewarp_1",
                            "port_index": 0
                        }
                    },
                    {
                        "id": "navigation",
                        "type": "DCAM_STREAM_TYPE_FILTER",
                        "usage": "DCAM_STREAM_USAGE_VISION",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "flag": [
                            "DCAM_STREAM_FLAG_ZERO_FRAME_BUFFER_ON_INIT"
                        ],
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2997",
                        "width": 1280,
                        "height": 720,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "buffer_nr": 10,
                        "priority": "high",
                        "sink_filters": [
                            {
                                "filter_id": "dzoom_2",
                                "port_index": 0
                            }
                        ],
                        "source_filter": {
                            "filter_id": "dzoom_1",
                            "port_index": 0
                        }
                    },
                    {
                        "id": "vision",
                        "type": "DCAM_STREAM_TYPE_FILTER",
                        "usage": "DCAM_STREAM_USAGE_VISION",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2997",
                        "width": 640,
                        "height": 360,
                        "width_alignment": 128,
                        "height_alignment": 480,
                        "vmem_flag": 31,
                        "buffer_nr": 10,
                        "priority": "high",
                        "source_filter": {
                            "filter_id": "dzoom_2",
                            "port_index": 0
                        }
                    },
                    {
                        "id": "video",
                        "type": "DCAM_STREAM_TYPE_FILTER",
                        "usage": "DCAM_STREAM_USAGE_VIDEO",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "flag": [
                            "DCAM_STREAM_FLAG_ON_DEMAND"
                        ],
                        "fps": "DCAM_FPS_2997",
                        "width": 3840,
                        "height": 2160,
                        "width_alignment": 128,
                        "height_alignment": 64,
                        "buffer_nr": 11,
                        "priority": "high",
                        "source_filter": {
                            "filter_id": "dewarp_1",
                            "port_index": 1
                        }
                    },
                    {
                        "id": "raw_dump",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_STILL",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_RAW16_OPAQUE",
                        "flag": [
                            "DCAM_STREAM_FLAG_ON_DEMAND"
                        ],
                        "fps": "DCAM_FPS_2997",
                        "width": 5472,
                        "height": 3078,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "buffer_nr": 2
                    }
                ]
            },
            {
                "id": "video_3840x2160_2997_10bit",
                "shooter_id": "video-single",
                "sensor_fps": "DCAM_FPS_2997",
                "filters": [
                    {
                        "type": "dzoom",
                        "id": "dzoom_1",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "dzoom",
                        "id": "dzoom_2",
                        "style": "pull",
                        "parameter": "strategy=crop_downscale;"
                    },
                    {
                        "type": "disp_eng",
                        "id": "disp_eng_1",
                        "style": "listen",
                        "parameter": "name=wm232;"
                    }
                ],
                "streams": [
                    {
                        "id": "liveview",
                        "copy_from": "video_5472x3078_2997_10bit/liveview",
                        "vmem_flag": 31,
                        "fps": "DCAM_FPS_2997"
                    },
                    {
                        "id": "navigation",
                        "copy_from": "video_5472x3078_2997_10bit/navigation",
                        "fps": "DCAM_FPS_2997"
                    },
                    {
                        "id": "vision",
                        "copy_from": "video_5472x3078_2997_10bit/vision",
                        "fps": "DCAM_FPS_2997"
                    },
                    {
                        "id": "yuv_piv",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_VIDEO",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV10_SP420_YUV",
                        "flag": [
                            "DCAM_STREAM_FLAG_ON_DEMAND"
                        ],
                        "fps": "DCAM_FPS_2997",
                        "width": 5472,
                        "height": 3078,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "buffer_nr": 5,
                        "priority": "high",
                        "sink_filters": [
                            {
                                "filter_id": "dzoom_2",
                                "port_index": 0
                            }
                        ]
                    },
                    {
                        "id": "video",
                        "type": "DCAM_STREAM_TYPE_FILTER",
                        "usage": "DCAM_STREAM_USAGE_VIDEO",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV10_SP420_YUV",
                        "flag": [
                            "DCAM_STREAM_FLAG_ON_DEMAND"
                        ],
                        "fps": "DCAM_FPS_2997",
                        "width": 3840,
                        "height": 2160,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "buffer_nr": 6,
                        "priority": "higher",
                        "source_filter": {
                            "filter_id": "dzoom_2",
                            "port_index": 0
                        }
                    },
                    {
                        "id": "raw_dump",
                        "copy_from": "video_5472x3078_2997_10bit/raw_dump",
                        "fps": "DCAM_FPS_2997"
                    }
                ]
            },
            {
                "id": "video_3840x2160_2997_quick-shot",
                "shooter_id": "video-single",
                "sensor_fps": "DCAM_FPS_2997",
                "filters": [
                    {
                        "type": "dzoom",
                        "id": "dzoom_1",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "dzoom",
                        "id": "dzoom_2",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "disp_eng",
                        "id": "disp_eng_1",
                        "style": "listen",
                        "parameter": "name=wm232;"
                    }
                ],
                "streams": [
                    {
                        "id": "liveview",
                        "copy_from": "video_5472x3078_2997_10bit/liveview",
                        "vmem_flag": 31,
                        "fps": "DCAM_FPS_2997"
                    },
                    {
                        "id": "navigation",
                        "copy_from": "video_5472x3078_2997_10bit/navigation",
                        "fps": "DCAM_FPS_2997"
                    },
                    {
                        "id": "vision",
                        "copy_from": "video_5472x3078_2997_10bit/vision",
                        "fps": "DCAM_FPS_2997"
                    },
                    {
                        "id": "yuv_piv",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_VIDEO",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "flag": [
                            "DCAM_STREAM_FLAG_ON_DEMAND"
                        ],
                        "fps": "DCAM_FPS_2997",
                        "width": 5472,
                        "height": 3078,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "buffer_nr": 6,
                        "priority": "high",
                        "sink_filters": [
                            {
                                "filter_id": "dzoom_2",
                                "port_index": 0
                            }
                        ]
                    },
                    {
                        "id": "video",
                        "type": "DCAM_STREAM_TYPE_FILTER",
                        "usage": "DCAM_STREAM_USAGE_VIDEO",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "flag": [
                            "DCAM_STREAM_FLAG_ON_DEMAND"
                        ],
                        "fps": "DCAM_FPS_2997",
                        "width": 3840,
                        "height": 2160,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "buffer_nr": 11,
                        "priority": "high",
                        "source_filter": {
                            "filter_id": "dzoom_2",
                            "port_index": 0
                        }
                    },
                    {
                        "id": "raw_dump",
                        "copy_from": "video_5472x3078_2997_10bit/raw_dump",
                        "fps": "DCAM_FPS_2997"
                    }
                ]
            },
            {
                "id": "video_3840x2160_2997_master-shot",
                "shooter_id": "video-single",
                "sensor_fps": "DCAM_FPS_2997",
                "digital_zoom_param": "support_dzoom=1;max_dzoom_ratio=42800;max_crop_ratio=14250;",
                "filters": [
                     {
                        "type": "dewarp-pro",
                        "id": "dewarp_1",
                        "style": "push",
                        "parameter": "dynamic_calc=true;supported_output_port=2;distortion_correction=false;"
                    },
                    {
                        "type": "dzoom",
                        "id": "dzoom_1",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "dzoom",
                        "id": "dzoom_2",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "disp_eng",
                        "id": "disp_eng_1",
                        "style": "listen",
                        "parameter": "name=wm232;"
                    }
                ],
                "streams": [
                    {
                        "id": "yuv_piv",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_VIDEO",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2997",
                        "width": 5472,
                        "height": 3078,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "buffer_nr": 6,
                        "priority": "high",
                        "sink_filters": [
                            {
                                "filter_id": "dewarp_1",
                                "port_index": 0
                            }
                        ]
                    },
                    {
                        "id": "liveview",
                        "type": "DCAM_STREAM_TYPE_FILTER",
                        "usage": "DCAM_STREAM_USAGE_LIVEVIEW",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2997",
                        "width": 1920,
                        "height": 1080,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "buffer_nr": 10,
                        "vmem_flag": 31,
                        "priority": "high",
                        "sink_filters": [
                            {
                                "filter_id": "dzoom_1",
                                "port_index": 0
                            },
                            {
                                "filter_id": "disp_eng_1",
                                "port_index": 0
                            }
                        ],
                        "source_filter": {
                            "filter_id": "dewarp_1",
                            "port_index": 0
                        }
                    },
                    {
                        "id": "navigation",
                        "type": "DCAM_STREAM_TYPE_FILTER",
                        "usage": "DCAM_STREAM_USAGE_VISION",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "flag": [
                            "DCAM_STREAM_FLAG_ZERO_FRAME_BUFFER_ON_INIT"
                        ],
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2997",
                        "width": 1280,
                        "height": 720,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "buffer_nr": 10,
                        "priority": "high",
                        "sink_filters": [
                            {
                                "filter_id": "dzoom_2",
                                "port_index": 0
                            }
                        ],
                        "source_filter": {
                            "filter_id": "dzoom_1",
                            "port_index": 0
                        }
                    },
                    {
                        "id": "vision",
                        "type": "DCAM_STREAM_TYPE_FILTER",
                        "usage": "DCAM_STREAM_USAGE_VISION",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2997",
                        "width": 640,
                        "height": 360,
                        "width_alignment": 128,
                        "height_alignment": 480,
                        "vmem_flag": 31,
                        "buffer_nr": 10,
                        "priority": "high",
                        "source_filter": {
                            "filter_id": "dzoom_2",
                            "port_index": 0
                        }
                    },
                    {
                        "id": "video",
                        "type": "DCAM_STREAM_TYPE_FILTER",
                        "usage": "DCAM_STREAM_USAGE_VIDEO",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "flag": [
                            "DCAM_STREAM_FLAG_ON_DEMAND"
                        ],
                        "fps": "DCAM_FPS_2997",
                        "width": 3840,
                        "height": 2160,
                        "width_alignment": 128,
                        "height_alignment": 64,
                        "buffer_nr": 11,
                        "priority": "high",
                        "source_filter": {
                            "filter_id": "dewarp_1",
                            "port_index": 1
                        }
                    },
                    {
                        "id": "raw_dump",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_STILL",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_RAW16_OPAQUE",
                        "flag": [
                            "DCAM_STREAM_FLAG_ON_DEMAND"
                        ],
                        "fps": "DCAM_FPS_2997",
                        "width": 5472,
                        "height": 3078,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "buffer_nr": 2
                    }
                ]
            },
            {
                "id": "video_3840x2160_2397",
                "shooter_id": "video-single",
                "sensor_fps": "DCAM_FPS_2397",
                "digital_zoom_param": "support_dzoom=1;max_dzoom_ratio=42800;max_crop_ratio=14250;",
                "filters": [
                    {
                        "type": "dewarp-pro",
                        "id": "dewarp_1",
                        "style": "push",
                        "parameter": "dynamic_calc=true;supported_output_port=2;distortion_correction=false;"
                    },
                    {
                        "type": "dzoom",
                        "id": "dzoom_1",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "dzoom",
                        "id": "dzoom_2",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "disp_eng",
                        "id": "disp_eng_1",
                        "style": "listen",
                        "parameter": "name=wm232;"
                    }
                ],
                "streams": [
                    {
                        "id": "liveview",
                        "copy_from": "video_3840x2160_2997/liveview",
                        "vmem_flag": 31,
                        "fps": "DCAM_FPS_2397"
                    },
                    {
                        "id": "navigation",
                        "copy_from": "video_3840x2160_2997/navigation",
                        "fps": "DCAM_FPS_2397"
                    },
                    {
                        "id": "vision",
                        "copy_from": "video_3840x2160_2997/vision",
                        "fps": "DCAM_FPS_2397"
                    },
                    {
                        "id": "yuv_piv",
                        "copy_from": "video_3840x2160_2997/yuv_piv",
                        "fps": "DCAM_FPS_2397"
                    },
                    {
                        "id": "video",
                        "copy_from": "video_3840x2160_2997/video",
                        "fps": "DCAM_FPS_2397"
                    },
                    {
                        "id": "raw_dump",
                        "copy_from": "video_3840x2160_2997/raw_dump",
                        "fps": "DCAM_FPS_2397"
                    }
                ]
            },
            {
                "id": "video_3840x2160_2397_10bit",
                "shooter_id": "video-single",
                "sensor_fps": "DCAM_FPS_2397",
                "filters": [
                    {
                        "type": "dzoom",
                        "id": "dzoom_1",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "dzoom",
                        "id": "dzoom_2",
                        "style": "pull",
                        "parameter": "strategy=crop_downscale;"
                    },
                    {
                        "type": "disp_eng",
                        "id": "disp_eng_1",
                        "style": "listen",
                        "parameter": "name=wm232;"
                    }
                ],
                "streams": [
                    {
                        "id": "liveview",
                        "copy_from": "video_3840x2160_2997_10bit/liveview",
                        "vmem_flag": 31,
                        "fps": "DCAM_FPS_2397"
                    },
                    {
                        "id": "navigation",
                        "copy_from": "video_3840x2160_2997_10bit/navigation",
                        "fps": "DCAM_FPS_2397"
                    },
                    {
                        "id": "vision",
                        "copy_from": "video_3840x2160_2997_10bit/vision",
                        "fps": "DCAM_FPS_2397"
                    },
                    {
                        "id": "yuv_piv",
                        "copy_from": "video_3840x2160_2997_10bit/yuv_piv",
                        "fps": "DCAM_FPS_2397"
                    },
                    {
                        "id": "video",
                        "copy_from": "video_3840x2160_2997_10bit/video",
                        "fps": "DCAM_FPS_2397"
                    },
                    {
                        "id": "raw_dump",
                        "copy_from": "video_3840x2160_2997_10bit/raw_dump",
                        "fps": "DCAM_FPS_2397"
                    }
                ]
            },
            {
                "id": "video_3840x2160_2500",
                "shooter_id": "video-single",
                "sensor_fps": "DCAM_FPS_2500",
                "digital_zoom_param": "support_dzoom=1;max_dzoom_ratio=42800;max_crop_ratio=14250;",
                "filters": [
                    {
                        "type": "dewarp-pro",
                        "id": "dewarp_1",
                        "style": "push",
                        "parameter": "dynamic_calc=true;supported_output_port=2;distortion_correction=false;"
                    },
                    {
                        "type": "dzoom",
                        "id": "dzoom_1",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "dzoom",
                        "id": "dzoom_2",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "disp_eng",
                        "id": "disp_eng_1",
                        "style": "listen",
                        "parameter": "name=wm232;"
                    }
                ],
                "streams": [
                    {
                        "id": "liveview",
                        "copy_from": "video_3840x2160_2997/liveview",
                        "vmem_flag": 31,
                        "fps": "DCAM_FPS_2500"
                    },
                    {
                        "id": "navigation",
                        "copy_from": "video_3840x2160_2997/navigation",
                        "fps": "DCAM_FPS_2500"
                    },
                    {
                        "id": "vision",
                        "copy_from": "video_3840x2160_2997/vision",
                        "fps": "DCAM_FPS_2500"
                    },
                    {
                        "id": "yuv_piv",
                        "copy_from": "video_3840x2160_2997/yuv_piv",
                        "fps": "DCAM_FPS_2500"
                    },
                    {
                        "id": "video",
                        "copy_from": "video_3840x2160_2997/video",
                        "fps": "DCAM_FPS_2500"
                    },
                    {
                        "id": "raw_dump",
                        "copy_from": "video_3840x2160_2997/raw_dump",
                        "fps": "DCAM_FPS_2500"
                    }
                ]
            },
            {
                "id": "video_3840x2160_2500_10bit",
                "shooter_id": "video-single",
                "sensor_fps": "DCAM_FPS_2500",
                "filters": [
                    {
                        "type": "dzoom",
                        "id": "dzoom_1",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "dzoom",
                        "id": "dzoom_2",
                        "style": "pull",
                        "parameter": "strategy=crop_downscale;"
                    },
                    {
                        "type": "disp_eng",
                        "id": "disp_eng_1",
                        "style": "listen",
                        "parameter": "name=wm232;"
                    }
                ],
                "streams": [
                    {
                        "id": "liveview",
                        "copy_from": "video_3840x2160_2997_10bit/liveview",
                        "vmem_flag": 31,
                        "fps": "DCAM_FPS_2500"
                    },
                    {
                        "id": "navigation",
                        "copy_from": "video_3840x2160_2997_10bit/navigation",
                        "fps": "DCAM_FPS_2500"
                    },
                    {
                        "id": "vision",
                        "copy_from": "video_3840x2160_2997_10bit/vision",
                        "fps": "DCAM_FPS_2500"
                    },
                    {
                        "id": "yuv_piv",
                        "copy_from": "video_3840x2160_2997_10bit/yuv_piv",
                        "fps": "DCAM_FPS_2500"
                    },
                    {
                        "id": "video",
                        "copy_from": "video_3840x2160_2997_10bit/video",
                        "fps": "DCAM_FPS_2500"
                    },
                    {
                        "id": "raw_dump",
                        "copy_from": "video_3840x2160_2997_10bit/raw_dump",
                        "fps": "DCAM_FPS_2500"
                    }
                ]
            },
            {
                "id": "video_1920x1080_5994",
                "shooter_id": "video-single",
                "sensor_fps": "DCAM_FPS_5994",
                "digital_zoom_param": "support_dzoom=1;max_dzoom_ratio=60000;max_crop_ratio=20000;",
                "filters": [
                    {
                        "type": "dewarp-pro",
                        "id": "dewarp_1",
                        "style": "push",
                        "parameter": "dynamic_calc=true;supported_output_port=2;distortion_correction=false;"
                    },
                    {
                        "type": "dzoom",
                        "id": "dzoom_1",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "dzoom",
                        "id": "dzoom_2",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "disp_eng",
                        "id": "disp_eng_1",
                        "style": "listen",
                        "parameter": "name=wm232;"
                    }
                ],
                "streams": [
                    {
                        "id": "yuv_piv",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_VIDEO",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_5994",
                        "width": 3840,
                        "height": 2160,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "buffer_nr": 16,
                        "vmem_flag": 31,
                        "priority": "high",
                        "sink_filters": [
                            {
                                "filter_id": "dewarp_1",
                                "port_index": 0
                            }
                        ]
                    },
                    {
                        "id": "liveview",
                        "type": "DCAM_STREAM_TYPE_FILTER",
                        "usage": "DCAM_STREAM_USAGE_LIVEVIEW",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2997",
                        "width": 1920,
                        "height": 1080,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "buffer_nr": 10,
                        "vmem_flag": 31,
                        "priority": "high",
                        "sink_filters": [
                            {
                                "filter_id": "dzoom_1",
                                "port_index": 0
                            },
                            {
                                "filter_id": "disp_eng_1",
                                "port_index": 0
                            }
                        ],
                        "source_filter": {
                            "filter_id": "dewarp_1",
                            "port_index": 0
                        }
                    },
                    {
                        "id": "navigation",
                        "type": "DCAM_STREAM_TYPE_FILTER",
                        "usage": "DCAM_STREAM_USAGE_VISION",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "flag": [
                            "DCAM_STREAM_FLAG_ZERO_FRAME_BUFFER_ON_INIT"
                        ],
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2997",
                        "width": 1280,
                        "height": 720,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "buffer_nr": 10,
                        "priority": "high",
                        "sink_filters": [
                            {
                                "filter_id": "dzoom_2",
                                "port_index": 0
                            }
                       ],
                       "source_filter": {
                            "filter_id": "dzoom_1",
                            "port_index": 0
                        }
                    },
                    {
                        "id": "vision",
                        "type": "DCAM_STREAM_TYPE_FILTER",
                        "usage": "DCAM_STREAM_USAGE_VISION",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2997",
                        "width": 640,
                        "height": 360,
                        "width_alignment": 128,
                        "height_alignment": 480,
                        "vmem_flag": 31,
                        "buffer_nr": 10,
                        "priority": "high",
                        "source_filter": {
                            "filter_id": "dzoom_2",
                            "port_index": 0
                        }
                    },
                    {
                        "id": "video",
                        "type": "DCAM_STREAM_TYPE_FILTER",
                        "usage": "DCAM_STREAM_USAGE_VIDEO",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "flag": [
                            "DCAM_STREAM_FLAG_ON_DEMAND"
                        ],
                        "fps": "DCAM_FPS_5994",
                        "width": 1920,
                        "height": 1080,
                        "width_alignment": 128,
                        "height_alignment": 64,
                        "buffer_nr": 16,
                        "priority": "high",
                        "source_filter": {
                            "filter_id": "dewarp_1",
                            "port_index": 1
                        }
                    },
                    {
                        "id": "raw_dump",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_STILL",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_RAW16_OPAQUE",
                        "flag": [
                            "DCAM_STREAM_FLAG_ON_DEMAND"
                        ],
                        "fps": "DCAM_FPS_5994",
                        "width": 3840,
                        "height": 2160,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "buffer_nr": 2
                    }
                ]
            },
            {
                "id": "video_1920x1080_5994_10bit",
                "shooter_id": "video-single",
                "sensor_fps": "DCAM_FPS_5994",
                "filters": [

                    {
                        "type": "dzoom",
                        "id": "dzoom_1",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "dzoom",
                        "id": "dzoom_2",
                        "style": "pull",
                        "parameter": "strategy=crop_downscale;"
                    },
                    {
                        "type": "disp_eng",
                        "id": "disp_eng_1",
                        "style": "listen",
                        "parameter": "name=wm232;"
                    }
                ],
                "streams": [
                    {
                        "id": "yuv_piv",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_VIDEO",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV10_SP420_YUV",
                        "flag": [
                            "DCAM_STREAM_FLAG_ON_DEMAND"
                        ],
                        "fps": "DCAM_FPS_5994",
                        "width": 3840,
                        "height": 2160,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "buffer_nr": 16,
                        "priority": "high",
                        "sink_filters": [
                            {
                                "filter_id": "dzoom_2",
                                "port_index": 0
                            }
                        ]
                    },
                    {
                        "id": "liveview",
                        "copy_from": "video_3840x2160_5994_10bit/liveview"
                    },
                    {
                        "id": "navigation",
                        "copy_from": "video_3840x2160_5994_10bit/navigation"
                    },
                    {
                        "id": "vision",
                        "copy_from": "video_3840x2160_5994_10bit/vision"
                    },
                    {
                        "id": "video",
                        "type": "DCAM_STREAM_TYPE_FILTER",
                        "usage": "DCAM_STREAM_USAGE_VIDEO",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV10_SP420_YUV",
                        "flag": [
                            "DCAM_STREAM_FLAG_ON_DEMAND"
                        ],
                        "fps": "DCAM_FPS_5994",
                        "width": 1920,
                        "height": 1080,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "buffer_nr": 16,
                        "priority": "higher",
                        "source_filter": {
                            "filter_id": "dzoom_2",
                            "port_index": 0
                        }
                    },
                    {
                        "id": "raw_dump",
                        "copy_from": "video_3840x2160_5994_10bit/raw_dump"
                    }
                ]
            },
            {
                "id": "video_1920x1080_5000",
                "shooter_id": "video-single",
                "sensor_fps": "DCAM_FPS_5000",
                "digital_zoom_param": "support_dzoom=1;max_dzoom_ratio=60000;max_crop_ratio=20000;",
                "filters": [
                    {
                        "type": "dewarp-pro",
                        "id": "dewarp_1",
                        "style": "push",
                        "parameter": "dynamic_calc=true;supported_output_port=2;distortion_correction=false;"
                    },
                    {
                        "type": "dzoom",
                        "id": "dzoom_1",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "dzoom",
                        "id": "dzoom_2",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "disp_eng",
                        "id": "disp_eng_1",
                        "style": "listen",
                        "parameter": "name=wm232;"
                    }
                ],
                "streams": [
                    {
                        "id": "yuv_piv",
                        "copy_from": "video_1920x1080_5994/yuv_piv",
                        "fps": "DCAM_FPS_5000"
                    },
                    {
                        "id": "liveview",
                        "copy_from": "video_1920x1080_5994/liveview",
                        "fps": "DCAM_FPS_2500"
                    },
                    {
                        "id": "navigation",
                        "copy_from": "video_1920x1080_5994/navigation",
                        "fps": "DCAM_FPS_2500"
                    },
                    {
                        "id": "vision",
                        "copy_from": "video_1920x1080_5994/vision",
                        "fps": "DCAM_FPS_2500"
                    },
                    {
                        "id": "video",
                        "copy_from": "video_1920x1080_5994/video",
                        "fps": "DCAM_FPS_5000"
                    },
                    {
                        "id": "raw_dump",
                        "copy_from": "video_1920x1080_5994/raw_dump",
                        "fps": "DCAM_FPS_5000"
                    }
                ]
            },
            {
                "id": "video_1920x1080_5000_10bit",
                "shooter_id": "video-single",
                "sensor_fps": "DCAM_FPS_5000",
                "filters": [
                    {
                        "type": "dzoom",
                        "id": "dzoom_1",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "dzoom",
                        "id": "dzoom_2",
                        "style": "pull",
                        "parameter": "strategy=crop_downscale;"
                    },
                    {
                        "type": "disp_eng",
                        "id": "disp_eng_1",
                        "style": "listen",
                        "parameter": "name=wm232;"
                    }
                ],
                "streams": [
                    {
                        "id": "yuv_piv",
                        "copy_from": "video_1920x1080_5994_10bit/yuv_piv",
                        "fps": "DCAM_FPS_5000"
                    },
                    {
                        "id": "liveview",
                        "copy_from": "video_1920x1080_5994_10bit/liveview",
                        "fps": "DCAM_FPS_2500"
                    },
                    {
                        "id": "navigation",
                        "copy_from": "video_1920x1080_5994_10bit/navigation",
                        "fps": "DCAM_FPS_2500"
                    },
                    {
                        "id": "vision",
                        "copy_from": "video_1920x1080_5994_10bit/vision",
                        "fps": "DCAM_FPS_2500"
                    },
                    {
                        "id": "video",
                        "copy_from": "video_1920x1080_5994_10bit/video",
                        "fps": "DCAM_FPS_5000"
                    },
                    {
                        "id": "raw_dump",
                        "copy_from": "video_1920x1080_5994_10bit/raw_dump",
                        "fps": "DCAM_FPS_5000"
                    }
                ]
            },
            {
                "id": "video_1920x1080_4795",
                "shooter_id": "video-single",
                "sensor_fps": "DCAM_FPS_4795",
                "digital_zoom_param": "support_dzoom=1;max_dzoom_ratio=60000;max_crop_ratio=20000;",
                "filters": [
                    {
                        "type": "dewarp-pro",
                        "id": "dewarp_1",
                        "style": "push",
                        "parameter": "dynamic_calc=true;supported_output_port=2;distortion_correction=false;"
                    },
                    {
                        "type": "dzoom",
                        "id": "dzoom_1",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "dzoom",
                        "id": "dzoom_2",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "disp_eng",
                        "id": "disp_eng_1",
                        "style": "listen",
                        "parameter": "name=wm232;"
                    }
                ],
                "streams": [
                    {
                        "id": "yuv_piv",
                        "copy_from": "video_1920x1080_5994/yuv_piv",
                        "fps": "DCAM_FPS_4795"
                    },
                    {
                        "id": "liveview",
                        "copy_from": "video_1920x1080_5994/liveview",
                        "fps": "DCAM_FPS_2397"
                    },
                    {
                        "id": "navigation",
                        "copy_from": "video_1920x1080_5994/navigation",
                        "fps": "DCAM_FPS_2397"
                    },
                    {
                        "id": "vision",
                        "copy_from": "video_1920x1080_5994/vision",
                        "fps": "DCAM_FPS_2397"
                    },
                    {
                        "id": "video",
                        "copy_from": "video_1920x1080_5994/video",
                        "fps": "DCAM_FPS_4795"
                    },
                    {
                        "id": "raw_dump",
                        "copy_from": "video_1920x1080_5994/raw_dump",
                        "fps": "DCAM_FPS_4795"
                    }
                ]
            },
            {
                "id": "video_1920x1080_4795_10bit",
                "shooter_id": "video-single",
                "sensor_fps": "DCAM_FPS_4795",
                "filters": [
                    {
                        "type": "dzoom",
                        "id": "dzoom_1",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "dzoom",
                        "id": "dzoom_2",
                        "style": "pull",
                        "parameter": "strategy=crop_downscale;"
                    },
                    {
                        "type": "disp_eng",
                        "id": "disp_eng_1",
                        "style": "listen",
                        "parameter": "name=wm232;"
                    }
                ],
                "streams": [
                    {
                        "id": "yuv_piv",
                        "copy_from": "video_1920x1080_5994_10bit/yuv_piv",
                        "fps": "DCAM_FPS_4795"
                    },
                    {
                        "id": "liveview",
                        "copy_from": "video_1920x1080_5994_10bit/liveview",
                        "fps": "DCAM_FPS_2397"
                    },
                    {
                        "id": "navigation",
                        "copy_from": "video_1920x1080_5994_10bit/navigation",
                        "fps": "DCAM_FPS_2397"
                    },
                    {
                        "id": "vision",
                        "copy_from": "video_1920x1080_5994_10bit/vision",
                        "fps": "DCAM_FPS_2397"
                    },
                    {
                        "id": "video",
                        "copy_from": "video_1920x1080_5994_10bit/video",
                        "fps": "DCAM_FPS_4795"
                    },
                    {
                        "id": "raw_dump",
                        "copy_from": "video_1920x1080_5994_10bit/raw_dump",
                        "fps": "DCAM_FPS_4795"
                    }
                ]
            },
            {
                "id": "video_1920x1080_2997",
                "shooter_id": "video-single",
                "sensor_fps": "DCAM_FPS_2997",
                "digital_zoom_param": "support_dzoom=1;max_dzoom_ratio=85500;max_crop_ratio=28500;",
                "filters": [
                    {
                        "type": "dewarp-pro",
                        "id": "dewarp_1",
                        "style": "pull",
                        "parameter": "dynamic_calc=true;scale_grade=2;distortion_correction=false;"
                    },
                    {
                        "type": "dzoom",
                        "id": "dzoom_1",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "dzoom",
                        "id": "dzoom_2",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "shadow",
                        "id": "shadow_1",
                        "style": "push",
                        "parameter": "supported_output_port=2;"
                    },
                    {
                        "type": "disp_eng",
                        "id": "disp_eng_1",
                        "style": "listen",
                        "parameter": "name=wm232;"
                    }
                ],
                "streams": [
                    {
                        "id": "yuv_piv",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_VIDEO",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2997",
                        "width": 5472,
                        "height": 3078,
                        "width_alignment": 128,
                        "height_alignment": 32,
                        "buffer_nr": 11,
                        "priority": "high",
                        "sink_filters": [
                            {
                                "filter_id": "dewarp_1",
                                "port_index": 0
                            }
                        ]
                    },
                    {
                        "id": "yuv_piv_dzoom",
                        "type": "DCAM_STREAM_TYPE_FILTER",
                        "usage": "DCAM_STREAM_USAGE_VIDEO",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2997",
                        "width": 1920,
                        "height": 1080,
                        "width_alignment": 128,
                        "height_alignment": 32,
                        "buffer_nr": 11,
                        "priority": "high",
                        "sink_filters": [
                            {
                                "filter_id": "shadow_1",
                                "port_index": 0
                            }
                        ],
                        "source_filter": {
                            "filter_id": "dewarp_1",
                            "port_index": 0
                        }
                    },
                    {
                        "id": "liveview",
                        "type": "DCAM_STREAM_TYPE_SHADOW",
                        "usage": "DCAM_STREAM_USAGE_VIDEO",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2997",
                        "width": 1920,
                        "height": 1080,
                        "width_alignment": 128,
                        "height_alignment": 32,
                        "buffer_nr": 11,
                        "vmem_flag": 31,
                        "priority": "high",
                        "sink_filters": [
                            {
                                "filter_id": "dzoom_1",
                                "port_index": 0
                            },
                            {
                                "filter_id": "disp_eng_1",
                                "port_index": 0
                            }
                        ],
                        "source_filter": {
                            "filter_id": "shadow_1",
                            "port_index": 0
                        }
                    },
                    {
                        "id": "video",
                        "type": "DCAM_STREAM_TYPE_SHADOW",
                        "usage": "DCAM_STREAM_USAGE_VIDEO",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "flag": [
                            "DCAM_STREAM_FLAG_ON_DEMAND"
                        ],
                        "fps": "DCAM_FPS_2997",
                        "width": 1920,
                        "height": 1080,
                        "width_alignment": 128,
                        "height_alignment": 32,
                        "buffer_nr": 11,
                        "priority": "high",
                        "source_filter": {
                            "filter_id": "shadow_1",
                            "port_index": 1
                        }
                    },
                    {
                        "id": "navigation",
                        "type": "DCAM_STREAM_TYPE_FILTER",
                        "usage": "DCAM_STREAM_USAGE_VISION",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "flag": [
                            "DCAM_STREAM_FLAG_ZERO_FRAME_BUFFER_ON_INIT"
                        ],
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2997",
                        "width": 1280,
                        "height": 720,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "buffer_nr": 10,
                        "priority": "high",
                        "sink_filters": [
                            {
                                "filter_id": "dzoom_2",
                                "port_index": 0
                            }
                        ],
                        "source_filter": {
                            "filter_id": "dzoom_1",
                            "port_index": 0
                        }
                    },
                    {
                        "id": "vision",
                        "type": "DCAM_STREAM_TYPE_FILTER",
                        "usage": "DCAM_STREAM_USAGE_VISION",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2997",
                        "width": 640,
                        "height": 360,
                        "width_alignment": 128,
                        "height_alignment": 480,
                        "vmem_flag": 31,
                        "buffer_nr": 10,
                        "priority": "high",
                        "source_filter": {
                            "filter_id": "dzoom_2",
                            "port_index": 0
                        }
                    },
                    {
                        "id": "raw_dump",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_STILL",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_RAW16_OPAQUE",
                        "flag": [
                            "DCAM_STREAM_FLAG_ON_DEMAND"
                        ],
                        "fps": "DCAM_FPS_2997",
                        "width": 5472,
                        "height": 3078,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "buffer_nr": 2
                    }
                ]
            },
            {
                "id": "video_1920x1080_2997_10bit",
                "shooter_id": "video-single",
                "sensor_fps": "DCAM_FPS_2997",
                "filters": [
                    {
                        "type": "dzoom",
                        "id": "dzoom_1",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "dzoom",
                        "id": "dzoom_2",
                        "style": "pull",
                        "parameter": "strategy=crop_downscale;"
                    },
                    {
                        "type": "disp_eng",
                        "id": "disp_eng_1",
                        "style": "listen",
                        "parameter": "name=wm232;"
                    }
                ],
                "streams": [
                    {
                        "id": "liveview",
                        "copy_from": "video_3840x2160_2997_10bit/liveview",
                        "fps": "DCAM_FPS_2997"
                    },
                    {
                        "id": "navigation",
                        "copy_from": "video_3840x2160_2997_10bit/navigation",
                        "fps": "DCAM_FPS_2997"
                    },
                    {
                        "id": "vision",
                        "copy_from": "video_3840x2160_2997_10bit/vision",
                        "fps": "DCAM_FPS_2997"
                    },
                    {
                        "id": "yuv_piv",
                        "copy_from": "video_3840x2160_2997_10bit/yuv_piv",
                        "fps": "DCAM_FPS_2997"
                    },
                    {
                        "id": "video",
                        "copy_from": "video_3840x2160_2997_10bit/video",
                        "fps": "DCAM_FPS_2997",
                        "width": 1920,
                        "height": 1080,
                        "buffer_nr": 11
                    },
                    {
                        "id": "raw_dump",
                        "copy_from": "video_3840x2160_2997_10bit/raw_dump",
                        "fps": "DCAM_FPS_2997"
                    }
                ]
            },
            {
                "id": "video_1920x1080_2997_quick-shot",
                "shooter_id": "video-single",
                "sensor_fps": "DCAM_FPS_2997",
                "filters": [
                    {
                        "type": "dzoom",
                        "id": "dzoom_1",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "dzoom",
                        "id": "dzoom_2",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "disp_eng",
                        "id": "disp_eng_1",
                        "style": "listen",
                        "parameter": "name=wm232;"
                    }
                ],
                "streams": [
                    {
                        "id": "liveview",
                        "copy_from": "video_3840x2160_2997_quick-shot/liveview",
                        "fps": "DCAM_FPS_2997"
                    },
                    {
                        "id": "navigation",
                        "copy_from": "video_3840x2160_2997_quick-shot/navigation",
                        "fps": "DCAM_FPS_2997"
                    },
                    {
                        "id": "vision",
                        "copy_from": "video_3840x2160_2997_quick-shot/vision",
                        "fps": "DCAM_FPS_2997"
                    },
                    {
                        "id": "yuv_piv",
                        "copy_from": "video_3840x2160_2997_quick-shot/yuv_piv",
                        "fps": "DCAM_FPS_2997"
                    },
                    {
                        "id": "video",
                        "copy_from": "video_3840x2160_2997_quick-shot/video",
                        "fps": "DCAM_FPS_2997",
                        "width": 1920,
                        "height": 1080
                    },
                    {
                        "id": "raw_dump",
                        "copy_from": "video_3840x2160_2997_quick-shot/raw_dump",
                        "fps": "DCAM_FPS_2997"
                    }
                ]
            },
            {
                "id": "video_1920x1080_2997_master-shot",
                "shooter_id": "video-single",
                "sensor_fps": "DCAM_FPS_2997",
                "digital_zoom_param": "support_dzoom=1;max_dzoom_ratio=85500;max_crop_ratio=28500;",
                "filters": [
                    {
                        "type": "dewarp-pro",
                        "id": "dewarp_1",
                        "style": "pull",
                        "parameter": "dynamic_calc=true;scale_grade=2;distortion_correction=false;"
                    },
                    {
                        "type": "dzoom",
                        "id": "dzoom_1",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "dzoom",
                        "id": "dzoom_2",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "shadow",
                        "id": "shadow_1",
                        "style": "push",
                        "parameter": "supported_output_port=2;"
                    },
                    {
                        "type": "disp_eng",
                        "id": "disp_eng_1",
                        "style": "listen",
                        "parameter": "name=wm232;"
                    }
                ],
                "streams": [
                    {
                        "id": "yuv_piv",
                        "copy_from": "video_1920x1080_2997/yuv_piv",
                        "fps": "DCAM_FPS_2997"
                    },
                    {
                        "id": "yuv_piv_dzoom",
                        "copy_from": "video_1920x1080_2997/yuv_piv_dzoom",
                        "fps": "DCAM_FPS_2997"
                    },
                    {
                        "id": "liveview",
                        "copy_from": "video_1920x1080_2997/liveview",
                        "fps": "DCAM_FPS_2997"
                    },
                    {
                        "id": "video",
                        "copy_from": "video_1920x1080_2997/video",
                        "fps": "DCAM_FPS_2997"
                    },
                    {
                        "id": "navigation",
                        "copy_from": "video_1920x1080_2997/navigation",
                        "fps": "DCAM_FPS_2997"
                    },
                    {
                        "id": "vision",
                        "copy_from": "video_1920x1080_2997/vision",
                        "fps": "DCAM_FPS_2997"
                    },
                    {
                        "id": "raw_dump",
                        "copy_from": "video_1920x1080_2997/raw_dump",
                        "fps": "DCAM_FPS_2997"
                    }
                ]
            },
            {
                "id": "video_1920x1080_2500",
                "shooter_id": "video-single",
                "sensor_fps": "DCAM_FPS_2500",
                "digital_zoom_param": "support_dzoom=1;max_dzoom_ratio=85500;max_crop_ratio=28500;",
                "filters": [
                    {
                        "type": "dewarp-pro",
                        "id": "dewarp_1",
                        "style": "pull",
                        "parameter": "dynamic_calc=true;scale_grade=2;distortion_correction=false;"
                    },
                    {
                        "type": "dzoom",
                        "id": "dzoom_1",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "shadow",
                        "id": "shadow_1",
                        "style": "push",
                        "parameter": "supported_output_port=2;"
                    },
                    {
                        "type": "dzoom",
                        "id": "dzoom_2",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "disp_eng",
                        "id": "disp_eng_1",
                        "style": "listen",
                        "parameter": "name=wm232;"
                    }
                ],
                "streams": [
                    {
                        "id": "yuv_piv",
                        "copy_from": "video_1920x1080_2997/yuv_piv",
                        "fps": "DCAM_FPS_2500"
                    },
                    {
                        "id": "yuv_piv_dzoom",
                        "copy_from": "video_1920x1080_2997/yuv_piv_dzoom",
                        "fps": "DCAM_FPS_2500"
                    },
                    {
                        "id": "liveview",
                        "copy_from": "video_1920x1080_2997/liveview",
                        "vmem_flag": 31,
                        "fps": "DCAM_FPS_2500"

                    },
                    {
                        "id": "video",
                        "copy_from": "video_1920x1080_2997/video",
                        "fps": "DCAM_FPS_2500"
                    },
                    {
                        "id": "navigation",
                        "copy_from": "video_1920x1080_2997/navigation",
                        "fps": "DCAM_FPS_2500"

                    },
                    {
                        "id": "vision",
                        "copy_from": "video_1920x1080_2997/vision",
                        "fps": "DCAM_FPS_2500"

                    },
                    {
                        "id": "raw_dump",
                        "copy_from": "video_1920x1080_2997/raw_dump",
                        "fps": "DCAM_FPS_2500"
                    }
                ]
            },
            {
                "id": "video_1920x1080_2500_10bit",
                "shooter_id": "video-single",
                "sensor_fps": "DCAM_FPS_2500",
                "filters": [
                    {
                        "type": "dzoom",
                        "id": "dzoom_1",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "dzoom",
                        "id": "dzoom_2",
                        "style": "pull",
                        "parameter": "strategy=crop_downscale;"
                    },
                    {
                        "type": "disp_eng",
                        "id": "disp_eng_1",
                        "style": "listen",
                        "parameter": "name=wm232;"
                    }
                ],
                "streams": [
                    {
                        "id": "liveview",
                        "copy_from": "video_1920x1080_2997_10bit/liveview",
                        "vmem_flag": 31,
                        "fps": "DCAM_FPS_2500"
                    },
                    {
                        "id": "navigation",
                        "copy_from": "video_1920x1080_2997_10bit/navigation",
                        "fps": "DCAM_FPS_2500"
                    },
                    {
                        "id": "vision",
                        "copy_from": "video_1920x1080_2997_10bit/vision",
                        "fps": "DCAM_FPS_2500"
                    },
                    {
                        "id": "yuv_piv",
                        "copy_from": "video_1920x1080_2997_10bit/yuv_piv",
                        "fps": "DCAM_FPS_2500"
                    },
                    {
                        "id": "video",
                        "copy_from": "video_1920x1080_2997_10bit/video",
                        "fps": "DCAM_FPS_2500"
                    },
                    {
                        "id": "raw_dump",
                        "copy_from": "video_1920x1080_2997_10bit/raw_dump",
                        "fps": "DCAM_FPS_2500"
                    }
                ]
            },
            {
                "id": "video_1920x1080_2397",
                "shooter_id": "video-single",
                "sensor_fps": "DCAM_FPS_2397",
                "digital_zoom_param": "support_dzoom=1;max_dzoom_ratio=85500;max_crop_ratio=28500;",
                "filters": [
                    {
                        "type": "dewarp-pro",
                        "id": "dewarp_1",
                        "style": "pull",
                        "parameter": "dynamic_calc=true;scale_grade=2;distortion_correction=false;"
                    },
                    {
                        "type": "dzoom",
                        "id": "dzoom_1",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "dzoom",
                        "id": "dzoom_2",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "shadow",
                        "id": "shadow_1",
                        "style": "push",
                        "parameter": "supported_output_port=2;"
                    },
                    {
                        "type": "disp_eng",
                        "id": "disp_eng_1",
                        "style": "listen",
                        "parameter": "name=wm232;"
                    }
                ],
                "streams": [
                    {
                        "id": "yuv_piv",
                        "copy_from": "video_1920x1080_2997/yuv_piv",
                        "fps": "DCAM_FPS_2397"
                    },
                    {
                        "id": "yuv_piv_dzoom",
                        "copy_from": "video_1920x1080_2997/yuv_piv_dzoom",
                        "fps": "DCAM_FPS_2397"
                    },
                    {
                        "id": "liveview",
                        "copy_from": "video_1920x1080_2997/liveview",
                        "vmem_flag": 31,
                        "fps": "DCAM_FPS_2397"

                    },
                    {
                        "id": "video",
                        "copy_from": "video_1920x1080_2997/video",
                        "fps": "DCAM_FPS_2397"
                    },
                    {
                        "id": "navigation",
                        "copy_from": "video_1920x1080_2997/navigation",
                        "fps": "DCAM_FPS_2397"

                    },
                    {
                        "id": "vision",
                        "copy_from": "video_1920x1080_2997/vision",
                        "fps": "DCAM_FPS_2397"
                    },
                    {
                        "id": "raw_dump",
                        "copy_from": "video_1920x1080_2997/raw_dump",
                        "fps": "DCAM_FPS_2397"
                    }
                ]
            },
            {
                "id": "video_1920x1080_2397_10bit",
                "shooter_id": "video-single",
                "sensor_fps": "DCAM_FPS_2397",
                "filters": [
                    {
                        "type": "dzoom",
                        "id": "dzoom_1",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "dzoom",
                        "id": "dzoom_2",
                        "style": "pull",
                        "parameter": "strategy=crop_downscale;"
                    },
                    {
                        "type": "disp_eng",
                        "id": "disp_eng_1",
                        "style": "listen",
                        "parameter": "name=wm232;"
                    }
                ],
                "streams": [
                    {
                        "id": "liveview",
                        "copy_from": "video_1920x1080_2997_10bit/liveview",
                        "vmem_flag": 31,
                        "fps": "DCAM_FPS_2397"
                    },
                    {
                        "id": "navigation",
                        "copy_from": "video_1920x1080_2997_10bit/navigation",
                        "fps": "DCAM_FPS_2397"
                    },
                    {
                        "id": "vision",
                        "copy_from": "video_1920x1080_2997_10bit/vision",
                        "fps": "DCAM_FPS_2397"
                    },
                    {
                        "id": "yuv_piv",
                        "copy_from": "video_1920x1080_2997_10bit/yuv_piv",
                        "fps": "DCAM_FPS_2397"
                    },
                    {
                        "id": "video",
                        "copy_from": "video_1920x1080_2997_10bit/video",
                        "fps": "DCAM_FPS_2397"
                    },
                    {
                        "id": "raw_dump",
                        "copy_from": "video_1920x1080_2997_10bit/raw_dump",
                        "fps": "DCAM_FPS_2397"
                    }
                ]
            },
            {
                "id": "video_1920x1080_12000",
                "shooter_id": "video-single",
                "sensor_fps": "DCAM_FPS_12000",
                "filters": [
                    {
                        "type": "shadow",
                        "id": "shadow_1",
                        "style": "push",
                        "parameter": "supported_output_port=2;"
                    },
                    {
                        "type": "dzoom",
                        "id": "dzoom_1",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "disp_eng",
                        "id": "disp_eng_1",
                        "style": "listen",
                        "parameter": "name=wm232;"
                    }
                ],
                "streams": [
                    {
                        "id": "yuv_piv",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_LIVEVIEW",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "flag": [
                            "DCAM_STREAM_FLAG_ON_DEMAND"
                        ],
                        "fps": "DCAM_FPS_12000",
                        "width": 1920,
                        "height": 1080,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "buffer_nr": 64,
                        "priority": "high",
                        "sink_filters": [
                            {
                                "filter_id": "shadow_1",
                                "port_index": 0
                            }
                        ]
                    },
                    {
                        "id": "video",
                        "type": "DCAM_STREAM_TYPE_SHADOW",
                        "usage": "DCAM_STREAM_USAGE_LIVEVIEW",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "flag": [
                            "DCAM_STREAM_FLAG_ON_DEMAND"
                        ],
                        "fps": "DCAM_FPS_12000",
                        "width": 1920,
                        "height": 1080,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "buffer_nr": 64,
                        "priority": "high",
                        "source_filter": {
                            "filter_id": "shadow_1",
                            "port_index": 1
                        }
                    },
                    {
                        "id": "liveview",
                        "type": "DCAM_STREAM_TYPE_SHADOW",
                        "usage": "DCAM_STREAM_USAGE_LIVEVIEW",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2997",
                        "width": 1920,
                        "height": 1080,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "buffer_nr": 64,
                        "vmem_flag": 31,
                        "priority": "high",
                        "source_filter": {
                            "filter_id": "shadow_1",
                            "port_index": 0
                        },
                        "sink_filters": [
                            {
                                "filter_id": "disp_eng_1",
                                "port_index": 0
                            }
                        ]
                    },
                    {
                        "id": "navigation",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_VISION",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "flag": [
                            "DCAM_STREAM_FLAG_ZERO_FRAME_BUFFER_ON_INIT"
                        ],
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2997",
                        "width": 1280,
                        "height": 720,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "buffer_nr": 10,
                        "priority": "high",
                        "sink_filters": [
                            {
                                "filter_id": "dzoom_1",
                                "port_index": 0
                            }
                        ]
                    },
                    {
                        "id": "vision",
                        "type": "DCAM_STREAM_TYPE_FILTER",
                        "usage": "DCAM_STREAM_USAGE_VISION",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2997",
                        "width": 640,
                        "height": 360,
                        "width_alignment": 128,
                        "height_alignment": 480,
                        "vmem_flag": 31,
                        "buffer_nr": 10,
                        "priority": "high",
                        "source_filter": {
                            "filter_id": "dzoom_1",
                            "port_index": 0
                        }
                    },
                    {
                        "id": "raw_dump",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_STILL",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_RAW16_OPAQUE",
                        "flag": [
                            "DCAM_STREAM_FLAG_ON_DEMAND"
                        ],
                        "fps": "DCAM_FPS_12000",
                        "width": 1920,
                        "height": 1080,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "buffer_nr": 2
                    }
                ]
            },
            {
                "id": "video_1920x1080_12000_10bit",
                "shooter_id": "video-single",
                "sensor_fps": "DCAM_FPS_12000",
                "filters": [
                    {
                        "type": "dzoom",
                        "id": "dzoom_1",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "dzoom",
                        "id": "dzoom_2",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "disp_eng",
                        "id": "disp_eng_1",
                        "style": "listen",
                        "parameter": "name=wm232;"
                    }
                ],
                "streams": [
                    {
                        "id": "liveview",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_LIVEVIEW",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2997",
                        "width": 1920,
                        "height": 1080,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "buffer_nr": 64,
                        "vmem_flag": 31,
                        "sink_filters": [
                            {
                                "filter_id": "disp_eng_1",
                                "port_index": 0
                            }
                        ]
                    },
                    {
                        "id": "video",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_VIDEO",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV10_SP420_YUV",
                        "flag": [
                            "DCAM_STREAM_FLAG_ON_DEMAND"
                        ],
                        "fps": "DCAM_FPS_12000",
                        "width": 1920,
                        "height": 1080,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "buffer_nr": 64,
                        "priority": "higher"
                    },
                    {
                        "id": "navigation",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_VISION",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "flag": [
                            "DCAM_STREAM_FLAG_ZERO_FRAME_BUFFER_ON_INIT"
                        ],
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2997",
                        "width": 1280,
                        "height": 720,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "buffer_nr": 10,
                        "priority": "high",
                        "sink_filters": [
                            {
                                "filter_id": "dzoom_1",
                                "port_index": 0
                            }
                        ]
                    },
                    {
                        "id": "vision",
                        "type": "DCAM_STREAM_TYPE_FILTER",
                        "usage": "DCAM_STREAM_USAGE_VISION",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2997",
                        "width": 640,
                        "height": 360,
                        "width_alignment": 128,
                        "height_alignment": 480,
                        "vmem_flag": 31,
                        "buffer_nr": 10,
                        "priority": "high",
                        "source_filter": {
                            "filter_id": "dzoom_1",
                            "port_index": 0
                        }
                    },
                    {
                        "id": "raw_dump",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_STILL",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_RAW16_OPAQUE",
                        "flag": [
                            "DCAM_STREAM_FLAG_ON_DEMAND"
                        ],
                        "fps": "DCAM_FPS_12000",
                        "width": 1920,
                        "height": 1080,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "buffer_nr": 2
                    }
                ]
            },
            {
                "id": "video_2688x1512_5994",
                "shooter_id": "video-single",
                "sensor_fps": "DCAM_FPS_5994",
                "digital_zoom_param": "support_dzoom=1;max_dzoom_ratio=42100;max_crop_ratio=14280;",
                "filters": [
                    {
                        "type": "dewarp-pro",
                        "id": "dewarp_1",
                        "style": "push",
                        "parameter": "dynamic_calc=true;supported_output_port=2;distortion_correction=false;"
                    },
                    {
                        "type": "dzoom",
                        "id": "dzoom_1",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "dzoom",
                        "id": "dzoom_2",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "disp_eng",
                        "id": "disp_eng_1",
                        "style": "listen",
                        "parameter": "name=wm232;"
                    }
                ],
                "streams": [
                    {
                        "id": "yuv_piv",
                        "copy_from": "video_1920x1080_5994/yuv_piv"
                    },
                    {
                        "id": "liveview",
                        "copy_from": "video_1920x1080_5994/liveview"
                    },
                    {
                        "id": "navigation",
                        "copy_from": "video_1920x1080_5994/navigation"
                    },
                    {
                        "id": "vision",
                        "copy_from": "video_1920x1080_5994/vision"
                    },
                    {
                        "id": "video",
                        "copy_from": "video_1920x1080_5994/video",
                        "fps": "DCAM_FPS_5994",
                        "width": 2688,
                        "height": 1512,
                        "width_alignment": 128,
                        "height_alignment": 64,
                        "buffer_nr": 16,
                        "priority": "high"
                    },
                    {
                        "id": "raw_dump",
                        "copy_from": "video_1920x1080_5994/raw_dump"
                    }
                ]
            },
            {
                "id": "video_2688x1512_5994_10bit",
                "shooter_id": "video-single",
                "sensor_fps": "DCAM_FPS_5994",
                "filters": [
                    {
                        "type": "dzoom",
                        "id": "dzoom_1",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "dzoom",
                        "id": "dzoom_2",
                        "style": "pull",
                        "parameter": "strategy=crop_downscale;"
                    },
                    {
                        "type": "disp_eng",
                        "id": "disp_eng_1",
                        "style": "listen",
                        "parameter": "name=wm232;"
                    }
                ],
                "streams": [
                    {
                        "id": "yuv_piv",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_VIDEO",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV10_SP420_YUV",
                        "flag": [
                            "DCAM_STREAM_FLAG_ON_DEMAND"
                        ],
                        "fps": "DCAM_FPS_5994",
                        "width": 3840,
                        "height": 2160,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "buffer_nr": 16,
                        "priority": "high",
                        "sink_filters": [
                            {
                                "filter_id": "dzoom_2",
                                "port_index": 0
                            }
                        ]
                    },
                    {
                        "id": "liveview",
                        "copy_from": "video_3840x2160_5994_10bit/liveview"
                    },
                    {
                        "id": "navigation",
                        "copy_from": "video_3840x2160_5994_10bit/navigation"
                    },
                    {
                        "id": "vision",
                        "copy_from": "video_3840x2160_5994_10bit/vision"
                    },
                    {
                        "id": "video",
                        "type": "DCAM_STREAM_TYPE_FILTER",
                        "usage": "DCAM_STREAM_USAGE_VIDEO",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV10_SP420_YUV",
                        "flag": [
                            "DCAM_STREAM_FLAG_ON_DEMAND"
                        ],
                        "fps": "DCAM_FPS_5994",
                        "width": 2688,
                        "height": 1512,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "buffer_nr": 16,
                        "priority": "higher",
                        "source_filter": {
                            "filter_id": "dzoom_2",
                            "port_index": 0
                        }
                    },
                    {
                        "id": "raw_dump",
                        "copy_from": "video_3840x2160_5994_10bit/raw_dump"
                    }
                ]
            },
            {
                "id": "video_2688x1512_5000",
                "shooter_id": "video-single",
                "sensor_fps": "DCAM_FPS_5000",
                "digital_zoom_param": "support_dzoom=1;max_dzoom_ratio=42100;max_crop_ratio=14280;",
                "filters": [
                    {
                        "type": "dewarp-pro",
                        "id": "dewarp_1",
                        "style": "push",
                        "parameter": "dynamic_calc=true;supported_output_port=2;distortion_correction=false;"
                    },
                    {
                        "type": "dzoom",
                        "id": "dzoom_1",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "dzoom",
                        "id": "dzoom_2",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "disp_eng",
                        "id": "disp_eng_1",
                        "style": "listen",
                        "parameter": "name=wm232;"
                    }
                ],
                "streams": [
                    {
                        "id": "yuv_piv",
                        "copy_from": "video_2688x1512_5994/yuv_piv",
                        "fps": "DCAM_FPS_5000"
                    },
                    {
                        "id": "liveview",
                        "copy_from": "video_2688x1512_5994/liveview",
                        "fps": "DCAM_FPS_2500"
                    },
                    {
                        "id": "navigation",
                        "copy_from": "video_2688x1512_5994/navigation",
                        "fps": "DCAM_FPS_2500"
                    },
                    {
                        "id": "vision",
                        "copy_from": "video_2688x1512_5994/vision",
                        "fps": "DCAM_FPS_2500"
                    },
                    {
                        "id": "video",
                        "copy_from": "video_2688x1512_5994/video",
                        "fps": "DCAM_FPS_5000"
                    },
                    {
                        "id": "raw_dump",
                        "copy_from": "video_2688x1512_5994/raw_dump",
                        "fps": "DCAM_FPS_5000"
                    }
                ]
            },
            {
                "id": "video_2688x1512_5000_10bit",
                "shooter_id": "video-single",
                "sensor_fps": "DCAM_FPS_5000",
                "filters": [
                    {
                        "type": "dzoom",
                        "id": "dzoom_1",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "dzoom",
                        "id": "dzoom_2",
                        "style": "pull",
                        "parameter": "strategy=crop_downscale;"
                    },
                    {
                        "type": "disp_eng",
                        "id": "disp_eng_1",
                        "style": "listen",
                        "parameter": "name=wm232;"
                    }
                ],
                "streams": [
                    {
                        "id": "yuv_piv",
                        "copy_from": "video_2688x1512_5994_10bit/yuv_piv",
                        "fps": "DCAM_FPS_5000"
                    },
                    {
                        "id": "liveview",
                        "copy_from": "video_2688x1512_5994_10bit/liveview",
                        "vmem_flag": 31,
                        "fps": "DCAM_FPS_2500"
                    },
                    {
                        "id": "navigation",
                        "copy_from": "video_2688x1512_5994_10bit/navigation",
                        "fps": "DCAM_FPS_2500"
                    },
                    {
                        "id": "vision",
                        "copy_from": "video_2688x1512_5994_10bit/vision",
                        "fps": "DCAM_FPS_2500"
                    },
                    {
                        "id": "video",
                        "copy_from": "video_2688x1512_5994_10bit/video",
                        "fps": "DCAM_FPS_5000"
                    },
                    {
                        "id": "raw_dump",
                        "copy_from": "video_2688x1512_5994_10bit/raw_dump",
                        "fps": "DCAM_FPS_5000"
                    }
                ]
            },
            {
                "id": "video_2688x1512_4795",
                "shooter_id": "video-single",
                "sensor_fps": "DCAM_FPS_4795",
                "digital_zoom_param": "support_dzoom=1;max_dzoom_ratio=42100;max_crop_ratio=14280;",
                "filters": [
                    {
                        "type": "dewarp-pro",
                        "id": "dewarp_1",
                        "style": "push",
                        "parameter": "dynamic_calc=true;supported_output_port=2;distortion_correction=false;"
                    },
                    {
                        "type": "dzoom",
                        "id": "dzoom_1",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "dzoom",
                        "id": "dzoom_2",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "disp_eng",
                        "id": "disp_eng_1",
                        "style": "listen",
                        "parameter": "name=wm232;"
                    }
                ],
                "streams": [
                    {
                        "id": "yuv_piv",
                        "copy_from": "video_2688x1512_5994/yuv_piv",
                        "fps": "DCAM_FPS_4795"
                    },
                    {
                        "id": "liveview",
                        "copy_from": "video_2688x1512_5994/liveview",
                        "vmem_flag": 31,
                        "fps": "DCAM_FPS_2397"
                    },
                    {
                        "id": "navigation",
                        "copy_from": "video_2688x1512_5994/navigation",
                        "fps": "DCAM_FPS_2397"
                    },
                    {
                        "id": "vision",
                        "copy_from": "video_2688x1512_5994/vision",
                        "fps": "DCAM_FPS_2397"
                    },
                    {
                        "id": "video",
                        "copy_from": "video_2688x1512_5994/video",
                        "fps": "DCAM_FPS_4795"
                    },
                    {
                        "id": "raw_dump",
                        "copy_from": "video_2688x1512_5994/raw_dump",
                        "fps": "DCAM_FPS_4795"
                    }
                ]
            },
            {
                "id": "video_2688x1512_4795_10bit",
                "shooter_id": "video-single",
                "sensor_fps": "DCAM_FPS_4795",
                "filters": [
                    {
                        "type": "dzoom",
                        "id": "dzoom_1",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "dzoom",
                        "id": "dzoom_2",
                        "style": "pull",
                        "parameter": "strategy=crop_downscale;"
                    },
                    {
                        "type": "disp_eng",
                        "id": "disp_eng_1",
                        "style": "listen",
                        "parameter": "name=wm232;"
                    }
                ],
                "streams": [
                    {
                        "id": "yuv_piv",
                        "copy_from": "video_2688x1512_5994_10bit/yuv_piv",
                        "fps": "DCAM_FPS_4795"
                    },
                    {
                        "id": "liveview",
                        "copy_from": "video_2688x1512_5994_10bit/liveview",
                        "vmem_flag": 31,
                        "fps": "DCAM_FPS_2397"
                    },
                    {
                        "id": "navigation",
                        "copy_from": "video_2688x1512_5994_10bit/navigation",
                        "fps": "DCAM_FPS_2397"
                    },
                    {
                        "id": "vision",
                        "copy_from": "video_2688x1512_5994_10bit/vision",
                        "fps": "DCAM_FPS_2397"
                    },
                    {
                        "id": "video",
                        "copy_from": "video_2688x1512_5994_10bit/video",
                        "fps": "DCAM_FPS_4795"
                    },
                    {
                        "id": "raw_dump",
                        "copy_from": "video_2688x1512_5994_10bit/raw_dump",
                        "fps": "DCAM_FPS_4795"
                    }
                ]
            },
            {
                "id": "video_2688x1512_2997",
                "shooter_id": "video-single",
                "sensor_fps": "DCAM_FPS_2997",
                "digital_zoom_param": "support_dzoom=1;max_dzoom_ratio=60000;max_crop_ratio=20350;",
                "filters": [
                    {
                        "type": "dewarp-pro",
                        "id": "dewarp_1",
                        "style": "push",
                        "parameter": "dynamic_calc=true;supported_output_port=2;distortion_correction=false;"
                    },
                    {
                        "type": "dzoom",
                        "id": "dzoom_1",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "dzoom",
                        "id": "dzoom_2",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "disp_eng",
                        "id": "disp_eng_1",
                        "style": "listen",
                        "parameter": "name=wm232;"
                    }
                ],
                "streams": [
                    {
                        "id": "liveview",
                        "copy_from": "video_3840x2160_2997/liveview",
                        "vmem_flag": 31,
                        "fps": "DCAM_FPS_2997"
                    },
                    {
                        "id": "navigation",
                        "copy_from": "video_3840x2160_2997/navigation",
                        "fps": "DCAM_FPS_2997"
                    },
                    {
                        "id": "vision",
                        "copy_from": "video_3840x2160_2997/vision",
                        "fps": "DCAM_FPS_2997"
                    },
                    {
                        "id": "yuv_piv",
                        "copy_from": "video_3840x2160_2997/yuv_piv",
                        "fps": "DCAM_FPS_2997"
                    },
                    {
                        "id": "video",
                        "copy_from": "video_3840x2160_2997/video",
                        "fps": "DCAM_FPS_2997",
                        "width": 2688,
                        "height": 1512,
                        "buffer_nr": 11
                    },
                    {
                        "id": "raw_dump",
                        "copy_from": "video_3840x2160_2997/raw_dump",
                        "fps": "DCAM_FPS_2997"
                    }
                ]
            },
            {
                "id": "video_2688x1512_2997_10bit",
                "shooter_id": "video-single",
                "sensor_fps": "DCAM_FPS_2997",
                "filters": [
                    {
                        "type": "dzoom",
                        "id": "dzoom_1",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "dzoom",
                        "id": "dzoom_2",
                        "style": "pull",
                        "parameter": "strategy=crop_downscale;"
                    },
                    {
                        "type": "disp_eng",
                        "id": "disp_eng_1",
                        "style": "listen",
                        "parameter": "name=wm232;"
                    }
                ],
                "streams": [
                    {
                        "id": "liveview",
                        "copy_from": "video_3840x2160_2997_10bit/liveview",
                        "vmem_flag": 31,
                        "fps": "DCAM_FPS_2997"
                    },
                    {
                        "id": "navigation",
                        "copy_from": "video_3840x2160_2997_10bit/navigation",
                        "fps": "DCAM_FPS_2997"
                    },
                    {
                        "id": "vision",
                        "copy_from": "video_3840x2160_2997_10bit/vision",
                        "fps": "DCAM_FPS_2997"
                    },
                    {
                        "id": "yuv_piv",
                        "copy_from": "video_3840x2160_2997_10bit/yuv_piv",
                        "fps": "DCAM_FPS_2997"
                    },
                    {
                        "id": "video",
                        "copy_from": "video_3840x2160_2997_10bit/video",
                        "fps": "DCAM_FPS_2997",
                        "width": 2688,
                        "height": 1512,
                        "buffer_nr": 11
                    },
                    {
                        "id": "raw_dump",
                        "copy_from": "video_3840x2160_2997_10bit/raw_dump",
                        "fps": "DCAM_FPS_2997"
                    }
                ]
            },
            {
                "id": "video_2688x1512_2997_quick-shot",
                "shooter_id": "video-single",
                "sensor_fps": "DCAM_FPS_2997",
                "filters": [
                    {
                        "type": "dzoom",
                        "id": "dzoom_1",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "dzoom",
                        "id": "dzoom_2",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "disp_eng",
                        "id": "disp_eng_1",
                        "style": "listen",
                        "parameter": "name=wm232;"
                    }
                ],
                "streams": [
                    {
                        "id": "liveview",
                        "copy_from": "video_3840x2160_2997_quick-shot/liveview",
                        "vmem_flag": 31,
                        "fps": "DCAM_FPS_2997"
                    },
                    {
                        "id": "navigation",
                        "copy_from": "video_3840x2160_2997_quick-shot/navigation",
                        "fps": "DCAM_FPS_2997"
                    },
                    {
                        "id": "vision",
                        "copy_from": "video_3840x2160_2997_quick-shot/vision",
                        "fps": "DCAM_FPS_2997"
                    },
                    {
                        "id": "yuv_piv",
                        "copy_from": "video_3840x2160_2997_quick-shot/yuv_piv",
                        "fps": "DCAM_FPS_2997"
                    },
                    {
                        "id": "video",
                        "copy_from": "video_3840x2160_2997_quick-shot/video",
                        "fps": "DCAM_FPS_2997",
                        "width": 2688,
                        "height": 1512
                    },
                    {
                        "id": "raw_dump",
                        "copy_from": "video_3840x2160_2997_quick-shot/raw_dump",
                        "fps": "DCAM_FPS_2997"
                    }
                ]
            },
            {
                "id": "video_2688x1512_2997_master-shot",
                "shooter_id": "video-single",
                "sensor_fps": "DCAM_FPS_2997",
                "digital_zoom_param": "support_dzoom=1;max_dzoom_ratio=60000;max_crop_ratio=20350;",
                "filters": [
                    {
                        "type": "dewarp-pro",
                        "id": "dewarp_1",
                        "style": "push",
                        "parameter": "dynamic_calc=true;supported_output_port=2;distortion_correction=false;"
                    },
                    {
                        "type": "dzoom",
                        "id": "dzoom_1",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "dzoom",
                        "id": "dzoom_2",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "disp_eng",
                        "id": "disp_eng_1",
                        "style": "listen",
                        "parameter": "name=wm232;"
                    }
                ],
                "streams": [
                    {
                        "id": "liveview",
                        "copy_from": "video_3840x2160_2997/liveview",
                        "vmem_flag": 31,
                        "fps": "DCAM_FPS_2997"
                    },
                    {
                        "id": "navigation",
                        "copy_from": "video_3840x2160_2997/navigation",
                        "fps": "DCAM_FPS_2997"
                    },
                    {
                        "id": "vision",
                        "copy_from": "video_3840x2160_2997/vision",
                        "fps": "DCAM_FPS_2997"
                    },
                    {
                        "id": "yuv_piv",
                        "copy_from": "video_3840x2160_2997/yuv_piv",
                        "fps": "DCAM_FPS_2997"
                    },
                    {
                        "id": "video",
                        "copy_from": "video_3840x2160_2997/video",
                        "fps": "DCAM_FPS_2997",
                        "width": 2688,
                        "height": 1512
                    },
                    {
                        "id": "raw_dump",
                        "copy_from": "video_3840x2160_2997/raw_dump",
                        "fps": "DCAM_FPS_2997"
                    }
                ]
            },
            {
                "id": "video_2688x1512_2500",
                "shooter_id": "video-single",
                "sensor_fps": "DCAM_FPS_2500",
                "digital_zoom_param": "support_dzoom=1;max_dzoom_ratio=60000;max_crop_ratio=20350;",
                "filters": [
                    {
                        "type": "dewarp-pro",
                        "id": "dewarp_1",
                        "style": "push",
                        "parameter": "dynamic_calc=true;supported_output_port=2;distortion_correction=false;"
                    },
                    {
                        "type": "dzoom",
                        "id": "dzoom_1",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "dzoom",
                        "id": "dzoom_2",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "disp_eng",
                        "id": "disp_eng_1",
                        "style": "listen",
                        "parameter": "name=wm232;"
                    }
                ],
                "streams": [
                    {
                        "id": "liveview",
                        "copy_from": "video_2688x1512_2997/liveview",
                        "vmem_flag": 31,
                        "fps": "DCAM_FPS_2500"
                    },
                    {
                        "id": "navigation",
                        "copy_from": "video_2688x1512_2997/navigation",
                        "fps": "DCAM_FPS_2500"
                    },
                    {
                        "id": "vision",
                        "copy_from": "video_2688x1512_2997/vision",
                        "fps": "DCAM_FPS_2500"
                    },
                    {
                        "id": "yuv_piv",
                        "copy_from": "video_2688x1512_2997/yuv_piv",
                        "fps": "DCAM_FPS_2500"
                    },
                    {
                        "id": "video",
                        "copy_from": "video_2688x1512_2997/video",
                        "fps": "DCAM_FPS_2500"
                    },
                    {
                        "id": "raw_dump",
                        "copy_from": "video_2688x1512_2997/raw_dump",
                        "fps": "DCAM_FPS_2500"
                    }
                ]
            },
            {
                "id": "video_2688x1512_2500_10bit",
                "shooter_id": "video-single",
                "sensor_fps": "DCAM_FPS_2500",
                "filters": [
                    {
                        "type": "dzoom",
                        "id": "dzoom_1",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "dzoom",
                        "id": "dzoom_2",
                        "style": "pull",
                        "parameter": "strategy=crop_downscale;"
                    },
                    {
                        "type": "disp_eng",
                        "id": "disp_eng_1",
                        "style": "listen",
                        "parameter": "name=wm232;"
                    }
                ],
                "streams": [
                    {
                        "id": "liveview",
                        "copy_from": "video_2688x1512_2997_10bit/liveview",
                        "vmem_flag": 31,
                        "fps": "DCAM_FPS_2500"
                    },
                    {
                        "id": "navigation",
                        "copy_from": "video_2688x1512_2997_10bit/navigation",
                        "fps": "DCAM_FPS_2500"
                    },
                    {
                        "id": "vision",
                        "copy_from": "video_2688x1512_2997_10bit/vision",
                        "fps": "DCAM_FPS_2500"
                    },
                    {
                        "id": "yuv_piv",
                        "copy_from": "video_2688x1512_2997_10bit/yuv_piv",
                        "fps": "DCAM_FPS_2500"
                    },
                    {
                        "id": "video",
                        "copy_from": "video_2688x1512_2997_10bit/video",
                        "fps": "DCAM_FPS_2500"
                    },
                    {
                        "id": "raw_dump",
                        "copy_from": "video_2688x1512_2997_10bit/raw_dump",
                        "fps": "DCAM_FPS_2500"
                    }
                ]
            },
            {
                "id": "video_2688x1512_2397",
                "shooter_id": "video-single",
                "sensor_fps": "DCAM_FPS_2397",
                "digital_zoom_param": "support_dzoom=1;max_dzoom_ratio=60000;max_crop_ratio=20350;",
                "filters": [
                    {
                        "type": "dewarp-pro",
                        "id": "dewarp_1",
                        "style": "push",
                        "parameter": "dynamic_calc=true;supported_output_port=2;distortion_correction=false;"
                    },
                    {
                        "type": "dzoom",
                        "id": "dzoom_1",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "dzoom",
                        "id": "dzoom_2",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "disp_eng",
                        "id": "disp_eng_1",
                        "style": "listen",
                        "parameter": "name=wm232;"
                    }
                ],
                "streams": [
                    {
                        "id": "liveview",
                        "copy_from": "video_2688x1512_2997/liveview",
                        "vmem_flag": 31,
                        "fps": "DCAM_FPS_2397"
                    },
                    {
                        "id": "navigation",
                        "copy_from": "video_2688x1512_2997/navigation",
                        "fps": "DCAM_FPS_2397"
                    },
                    {
                        "id": "vision",
                        "copy_from": "video_2688x1512_2997/vision",
                        "fps": "DCAM_FPS_2397"
                    },
                    {
                        "id": "yuv_piv",
                        "copy_from": "video_2688x1512_2997/yuv_piv",
                        "fps": "DCAM_FPS_2397"

                    },
                    {
                        "id": "video",
                        "copy_from": "video_2688x1512_2997/video",
                        "fps": "DCAM_FPS_2397"
                    },
                    {
                        "id": "raw_dump",
                        "copy_from": "video_2688x1512_2997/raw_dump",
                        "fps": "DCAM_FPS_2397"
                    }
                ]
            },
            {
                "id": "video_2688x1512_2397_10bit",
                "shooter_id": "video-single",
                "sensor_fps": "DCAM_FPS_2397",
                "filters": [
                    {
                        "type": "dzoom",
                        "id": "dzoom_1",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "dzoom",
                        "id": "dzoom_2",
                        "style": "pull",
                        "parameter": "strategy=crop_downscale;"
                    },
                    {
                        "type": "disp_eng",
                        "id": "disp_eng_1",
                        "style": "listen",
                        "parameter": "name=wm232;"
                    }
                ],
                "streams": [
                    {
                        "id": "liveview",
                        "copy_from": "video_2688x1512_2997_10bit/liveview",
                        "vmem_flag": 31,
                        "fps": "DCAM_FPS_2397"
                    },
                    {
                        "id": "navigation",
                        "copy_from": "video_2688x1512_2997_10bit/navigation",
                        "fps": "DCAM_FPS_2397"
                    },
                    {
                        "id": "vision",
                        "copy_from": "video_2688x1512_2997_10bit/vision",
                        "fps": "DCAM_FPS_2397"
                    },
                    {
                        "id": "yuv_piv",
                        "copy_from": "video_2688x1512_2997_10bit/yuv_piv",
                        "fps": "DCAM_FPS_2397"
                    },
                    {
                        "id": "video",
                        "copy_from": "video_2688x1512_2997_10bit/video",
                        "fps": "DCAM_FPS_2397"
                    },
                    {
                        "id": "raw_dump",
                        "copy_from": "video_2688x1512_2997_10bit/raw_dump",
                        "fps": "DCAM_FPS_2397"
                    }
                ]
            },
            {
                "id": "video_3840x2160_5994_online",
                "shooter_id": "video-single",
                "sensor_fps": "DCAM_FPS_5994",
                "filters": [
                    {
                        "type": "dzoom",
                        "id": "dzoom_1",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "disp_eng",
                        "id": "disp_eng_1",
                        "style": "listen",
                        "parameter": "name=wm232_online;"
                    }
                ],
                "streams": [
                    {
                        "id": "liveview",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_LIVEVIEW",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP422_YUV",
                        "fps": "DCAM_FPS_5994",
                        "width": 1920,
                        "height": 1080,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "buffer_nr": 10,
                        "priority": "high",
                        "sink_filters": [
                            {
                                "filter_id": "disp_eng_1",
                                "port_index": 0
                            }
                        ]
                    },
                    {
                        "id": "navigation",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_VISION",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "flag": [
                            "DCAM_STREAM_FLAG_ZERO_FRAME_BUFFER_ON_INIT"
                        ],
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2997",
                        "width": 1280,
                        "height": 720,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "buffer_nr": 10,
                        "sink_filters": [
                            {
                                "filter_id": "dzoom_1",
                                "port_index": 0
                            }
                       ]
                    },
                    {
                        "id": "vision",
                        "type": "DCAM_STREAM_TYPE_FILTER",
                        "usage": "DCAM_STREAM_USAGE_VISION",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2997",
                        "width": 640,
                        "height": 360,
                        "width_alignment": 128,
                        "height_alignment": 480,
                        "vmem_flag": 31,
                        "buffer_nr": 10,
                        "source_filter": {
                            "filter_id": "dzoom_1",
                            "port_index": 0
                        }
                    },
                    {
                        "id": "video",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_VIDEO",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "flag": [
                            "DCAM_STREAM_FLAG_ON_DEMAND"
                        ],
                        "fps": "DCAM_FPS_5994",
                        "width": 3840,
                        "height": 2160,
                        "width_alignment": 128,
                        "height_alignment": 64,
                        "buffer_nr": 16,
                        "priority": "high"
                    },
                    {
                        "id": "raw_dump",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_STILL",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_RAW16_OPAQUE",
                        "flag": [
                            "DCAM_STREAM_FLAG_ON_DEMAND"
                        ],
                        "fps": "DCAM_FPS_5994",
                        "width": 3840,
                        "height": 2160,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "buffer_nr": 2
                    }
                ]
            },
            {
                "id": "video_2688x1512_5994_online",
                "shooter_id": "video-single",
                "sensor_fps": "DCAM_FPS_5994",
                "filters": [
                    {
                        "type": "dzoom",
                        "id": "dzoom_1",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "dzoom",
                        "id": "dzoom_2",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "disp_eng",
                        "id": "disp_eng_1",
                        "style": "listen",
                        "parameter": "name=wm232_online;"
                    }
                ],
                "streams": [
                    {
                        "id": "yuv_piv",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_VIDEO",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_5994",
                        "width": 3840,
                        "height": 2160,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "buffer_nr": 16,
                        "priority": "high",
                        "sink_filters": [
                            {
                                "filter_id": "dzoom_2",
                                "port_index": 0
                            }
                        ]
                    },
                    {
                        "id": "liveview",
                        "copy_from": "video_3840x2160_5994_online/liveview"
                    },
                    {
                        "id": "navigation",
                        "copy_from": "video_3840x2160_5994_online/navigation"
                    },
                    {
                        "id": "vision",
                        "copy_from": "video_3840x2160_5994_online/vision"
                    },
                    {
                        "id": "video",
                        "type": "DCAM_STREAM_TYPE_FILTER",
                        "usage": "DCAM_STREAM_USAGE_VIDEO",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV10_SP420_YUV",
                        "flag": [
                            "DCAM_STREAM_FLAG_ON_DEMAND"
                        ],
                        "fps": "DCAM_FPS_5994",
                        "width": 2688,
                        "height": 1512,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "buffer_nr": 16,
                        "priority": "high",
                        "source_filter": {
                            "filter_id": "dzoom_2",
                            "port_index": 0
                        }
                    },
                    {
                        "id": "raw_dump",
                        "copy_from": "video_3840x2160_5994_online/raw_dump"
                    }
                ]
            },
            {
                "id": "video_1920x1080_5994_online",
                "shooter_id": "video-single",
                "sensor_fps": "DCAM_FPS_5994",
                "filters": [
                    {
                        "type": "dzoom",
                        "id": "dzoom_1",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "dzoom",
                        "id": "dzoom_2",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "disp_eng",
                        "id": "disp_eng_1",
                        "style": "listen",
                        "parameter": "name=wm232_online;"
                    }
                ],
                "streams": [
                    {
                        "id": "yuv_piv",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_VIDEO",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_5994",
                        "width": 3840,
                        "height": 2160,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "buffer_nr": 16,
                        "priority": "high",
                        "sink_filters": [
                            {
                                "filter_id": "dzoom_2",
                                "port_index": 0
                            }
                        ]
                    },
                    {
                        "id": "liveview",
                        "copy_from": "video_3840x2160_5994_online/liveview"
                    },
                    {
                        "id": "navigation",
                        "copy_from": "video_3840x2160_5994_online/navigation"
                    },
                    {
                        "id": "vision",
                        "copy_from": "video_3840x2160_5994_online/vision"
                    },
                    {
                        "id": "video",
                        "type": "DCAM_STREAM_TYPE_FILTER",
                        "usage": "DCAM_STREAM_USAGE_VIDEO",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV10_SP420_YUV",
                        "flag": [
                            "DCAM_STREAM_FLAG_ON_DEMAND"
                        ],
                        "fps": "DCAM_FPS_5994",
                        "width": 1920,
                        "height": 1080,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "buffer_nr": 16,
                        "priority": "high",
                        "source_filter": {
                            "filter_id": "dzoom_2",
                            "port_index": 0
                        }
                    },
                    {
                        "id": "raw_dump",
                        "copy_from": "video_3840x2160_5994_online/raw_dump"
                    }
                ]
            },
            {
                "id": "still_3x2_hyperlapse",
                "shooter_id": "still-hyperlapse_shot",
                "shooter_param": "res=3x2_hyperlapse;normal_cap=offline;",
                "still_raw_process_pipe": [
                    {
                        "id": "raw_process_pipe",
                        "nodes": [
                            {
                                "id": "input",
                                "param": ""
                            },
                            {
                                "id": "ob",
                                "param": "output_buffer_nr=2;dsp_cores=20;outstanding_mask=100663296;"
                            }
                        ]
                    }
                ],
                "still_process_pipe": [
                    {
                        "id": "main_pipe",
                        "nodes": [
                            {
                                "id": "input",
                                "param": ""
                            }
                        ]
                    }
                ],
                "sensor_fps": "DCAM_FPS_2500",
                "filters": [
                    {
                        "type": "dzoom",
                        "id": "dzoom_1",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "eis",
                        "id": "eis_1",
                        "style": "pull",
                        "parameter": "in_width=2720;in_height=1530;out_width=1920;out_height=1080;mesh_fmt=HYPE_GDC_MESH_FMT_32x32;"
                    },
                    {
                        "type": "disp_eng",
                        "id": "disp_eng_1",
                        "style": "listen",
                        "parameter": "name=wm232;"
                    }
                ],
                "streams": [
                    {
                        "id": "liveview",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_LIVEVIEW",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2500",
                        "width": 1632,
                        "height": 1088,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "vmem_flag": 31,
                        "buffer_nr": 11,
                        "sink_filters": [
                            {
                                "filter_id": "disp_eng_1",
                                "port_index": 0
                            }
                        ]
                    },
                    {
                        "id": "navigation",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_VISION",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2500",
                        "width": 1280,
                        "height": 720,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "vmem_flag": 31,
                        "buffer_nr": 10,
                        "priority": "high",
                        "sink_filters": [
                            {
                                "filter_id": "dzoom_1",
                                "port_index": 0
                            }
                        ]
                    },
                    {
                        "id": "vision",
                        "type": "DCAM_STREAM_TYPE_FILTER",
                        "usage": "DCAM_STREAM_USAGE_VISION",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2500",
                        "width": 640,
                        "height": 360,
                        "width_alignment": 128,
                        "height_alignment": 480,
                        "vmem_flag": 31,
                        "buffer_nr": 10,
                        "priority": "high",
                        "source_filter": {
                            "filter_id": "dzoom_1",
                            "port_index": 0
                        }
                    },
                    {
                        "id": "yuv_piv",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_STILL",
                        "behavior": "DCAM_STREAM_BEHAVIOR_PERREQUEST",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "flag": [
                            "DCAM_STREAM_FLAG_ON_DEMAND"
                        ],
                        "fps": "DCAM_FPS_1500",
                        "width": 5472,
                        "height": 3648,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "buffer_nr": 4
                    },
                    {
                        "id": "still_raw",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_STILL",
                        "behavior": "DCAM_STREAM_BEHAVIOR_PERREQUEST",
                        "format": "DUSS_PIXFMT_RAW16_OPAQUE",
                        "width": 5568,
                        "height": 3648,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "vmem_flag": 31,
                        "buffer_nr": 4
                    },
                    {
                        "id": "dec_video",
                        "type": "DCAM_STREAM_TYPE_DECODE",
                        "usage": "DCAM_STREAM_USAGE_VIDEO",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "flag": [
                            "DCAM_STREAM_FLAG_ON_DEMAND"
                        ],
                        "fps": "DCAM_FPS_2500",
                        "width": 2720,
                        "height": 1530,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "buffer_nr": 3,
                        "sink_filters": [
                            {
                                "filter_id": "eis_1",
                                "port_index": 0
                            }
                        ]
                    },
                    {
                        "id": "video",
                        "type": "DCAM_STREAM_TYPE_FILTER",
                        "usage": "DCAM_STREAM_USAGE_VIDEO",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "flag": [
                            "DCAM_STREAM_FLAG_ON_DEMAND"
                        ],
                        "fps": "DCAM_FPS_2500",
                        "width": 1920,
                        "height": 1080,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "buffer_nr": 3,
                        "source_filter": {
                            "filter_id": "eis_1",
                            "port_index": 0
                        }
                    }
                ]
            },
            {
                "id": "still_3x2_4k_hyperlapse",
                "shooter_id": "still-hyperlapse_shot",
                "shooter_param": "res=3x2_hyperlapse;normal_cap=offline;",
                "still_raw_process_pipe": [
                    {
                        "id": "raw_process_pipe",
                        "nodes": [
                            {
                                "id": "input",
                                "param": ""
                            },
                            {
                                "id": "ob",
                                "param": "output_buffer_nr=2;dsp_cores=20;outstanding_mask=102261126;"
                            }
                        ]
                    }
                ],
                "still_process_pipe": [
                    {
                        "id": "main_pipe",
                        "nodes": [
                            {
                                "id": "input",
                                "param": ""
                            }
                        ]
                    }
                ],
                "sensor_fps": "DCAM_FPS_2500",
                "filters": [
                    {
                        "type": "dzoom",
                        "id": "dzoom_1",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "eis",
                        "id": "eis_1",
                        "style": "pull",
                        "parameter": "in_width=5472;in_height=3072;out_width=3840;out_height=2160;dji_gdc=1;mesh_fmt=HYPE_GDC_MESH_FMT_32x32;"
                    },
                    {
                        "type": "disp_eng",
                        "id": "disp_eng_1",
                        "style": "listen",
                        "parameter": "name=wm232;"
                    }
                ],
                "streams": [
                    {
                        "id": "liveview",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_LIVEVIEW",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2500",
                        "width": 1632,
                        "height": 1088,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "vmem_flag": 31,
                        "buffer_nr": 11,
                        "sink_filters": [
                            {
                                "filter_id": "disp_eng_1",
                                "port_index": 0
                            }
                        ]
                    },
                    {
                        "id": "navigation",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_VISION",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2500",
                        "width": 1280,
                        "height": 720,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "vmem_flag": 31,
                        "buffer_nr": 10,
                        "priority": "high",
                        "sink_filters": [
                            {
                                "filter_id": "dzoom_1",
                                "port_index": 0
                            }
                        ]
                    },
                    {
                        "id": "vision",
                        "type": "DCAM_STREAM_TYPE_FILTER",
                        "usage": "DCAM_STREAM_USAGE_VISION",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2500",
                        "width": 640,
                        "height": 360,
                        "width_alignment": 128,
                        "height_alignment": 480,
                        "vmem_flag": 31,
                        "buffer_nr": 10,
                        "priority": "high",
                        "source_filter": {
                            "filter_id": "dzoom_1",
                            "port_index": 0
                        }
                    },
                    {
                        "id": "yuv_piv",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_STILL",
                        "behavior": "DCAM_STREAM_BEHAVIOR_PERREQUEST",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "flag": [
                            "DCAM_STREAM_FLAG_ON_DEMAND"
                        ],
                        "fps": "DCAM_FPS_1500",
                        "width": 5472,
                        "height": 3648,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "buffer_nr": 4
                    },
                    {
                        "id": "still_raw",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_STILL",
                        "behavior": "DCAM_STREAM_BEHAVIOR_PERREQUEST",
                        "format": "DUSS_PIXFMT_RAW16_OPAQUE",
                        "width": 5568,
                        "height": 3648,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "vmem_flag": 31,
                        "buffer_nr": 4
                    },
                    {
                        "id": "dec_video",
                        "type": "DCAM_STREAM_TYPE_DECODE",
                        "usage": "DCAM_STREAM_USAGE_VIDEO",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "flag": [
                            "DCAM_STREAM_FLAG_ON_DEMAND"
                        ],
                        "fps": "DCAM_FPS_2500",
                        "width": 5472,
                        "height": 3072,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "buffer_nr": 3,
                        "sink_filters": [
                            {
                                "filter_id": "eis_1",
                                "port_index": 0
                            }
                        ]
                    },
                    {
                        "id": "video",
                        "type": "DCAM_STREAM_TYPE_FILTER",
                        "usage": "DCAM_STREAM_USAGE_VIDEO",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "flag": [
                            "DCAM_STREAM_FLAG_ON_DEMAND"
                        ],
                        "fps": "DCAM_FPS_2500",
                        "width": 3840,
                        "height": 2160,
                        "width_alignment": 128,
                        "height_alignment": 32,
                        "buffer_nr": 3,
                        "source_filter": {
                            "filter_id": "eis_1",
                            "port_index": 0
                        }
                    }
                ]
            },
            {
                "id": "video_1920x1080_2500_asteroid",
                "shooter_id": "video-quick_shot",
                "sensor_fps": "DCAM_FPS_2500",
                "still_process_pipe": [
                    {
                        "id": "pano_pipe",
                        "nodes": [
                            {
                                "id": "input",
                                "param": ""
                            }
                        ]
                    }
                ],
                "filters": [
                    {
                        "type": "shadow",
                        "id": "shadow_1",
                        "style": "push",
                        "parameter": "supported_output_port=2;"
                    },
                    {
                        "type": "dzoom",
                        "id": "dzoom_1",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "dzoom",
                        "id": "dzoom_2",
                        "style": "pull",
                        "parameter": "strategy=crop_downscale;"
                    },
                    {
                        "type": "dzoom",
                        "id": "dzoom_3",
                        "style": "pull",
                        "parameter": "strategy=crop_downscale;"
                    },
                    {
                        "type": "disp_eng",
                        "id": "disp_eng_1",
                        "style": "listen",
                        "parameter": "name=wm232;"
                    }
                ],
                "streams": [
                    {
                        "id": "yuv_piv",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_LIVEVIEW",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "flag": [
                            "DCAM_STREAM_FLAG_ON_DEMAND"
                        ],
                        "fps": "DCAM_FPS_2500",
                        "width": 2280,
                        "height": 1520,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "buffer_nr": 20,
                        "priority": "high",
                        "sink_filters": [
                            {
                                "filter_id": "shadow_1",
                                "port_index": 0
                            }
                        ]
                    },
                    {
                        "id": "video_shadow",
                        "type": "DCAM_STREAM_TYPE_SHADOW",
                        "usage": "DCAM_STREAM_USAGE_LIVEVIEW",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "flag": [
                            "DCAM_STREAM_FLAG_ON_DEMAND"
                        ],
                        "fps": "DCAM_FPS_2500",
                        "width": 2280,
                        "height": 1520,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "buffer_nr": 20,
                        "priority": "high",
                        "source_filter": {
                            "filter_id": "shadow_1",
                            "port_index": 1
                        },
                        "sink_filters": [
                            {
                                "filter_id": "dzoom_2",
                                "port_index": 0
                            }
                        ]
                    },
                    {
                        "id": "video",
                        "type": "DCAM_STREAM_TYPE_FILTER",
                        "usage": "DCAM_STREAM_USAGE_VIDEO",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "flag": [
                            "DCAM_STREAM_FLAG_ON_DEMAND"
                        ],
                        "fps": "DCAM_FPS_2500",
                        "width": 1920,
                        "height": 1080,
                        "width_alignment": 128,
                        "height_alignment": 64,
                        "buffer_nr": 11,
                        "source_filter": {
                            "filter_id": "dzoom_2",
                            "port_index": 0
                        }
                    },
                    {
                        "id": "liveview_shadow",
                        "type": "DCAM_STREAM_TYPE_SHADOW",
                        "usage": "DCAM_STREAM_USAGE_LIVEVIEW",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "flag": [
                            "DCAM_STREAM_FLAG_ON_DEMAND"
                        ],
                        "fps": "DCAM_FPS_2500",
                        "width": 2280,
                        "height": 1520,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "buffer_nr": 20,
                        "priority": "high",
                        "source_filter": {
                            "filter_id": "shadow_1",
                            "port_index": 0
                        },
                        "sink_filters": [
                            {
                                "filter_id": "dzoom_3",
                                "port_index": 0
                            }
                        ]
                    },
                    {
                        "id": "liveview",
                        "type": "DCAM_STREAM_TYPE_FILTER",
                        "usage": "DCAM_STREAM_USAGE_LIVEVIEW",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2500",
                        "width": 1920,
                        "height": 1080,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "buffer_nr": 11,
                        "vmem_flag": 31,
                        "priority": "high",
                        "source_filter": {
                            "filter_id": "dzoom_3",
                            "port_index": 0
                        },
                        "sink_filters": [
                            {
                                "filter_id": "disp_eng_1",
                                "port_index": 0
                            }
                        ]
                    },
                    {
                        "id": "navigation",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_VISION",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "flag": [
                            "DCAM_STREAM_FLAG_ZERO_FRAME_BUFFER_ON_INIT"
                        ],
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2500",
                        "width": 1280,
                        "height": 720,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "buffer_nr": 10,
                        "priority": "high",
                        "sink_filters": [
                            {
                                "filter_id": "dzoom_1",
                                "port_index": 0
                            }
                        ]
                    },
                    {
                        "id": "vision",
                        "type": "DCAM_STREAM_TYPE_FILTER",
                        "usage": "DCAM_STREAM_USAGE_VISION",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_YUV8_SP420_YUV",
                        "fps": "DCAM_FPS_2500",
                        "width": 640,
                        "height": 360,
                        "width_alignment": 128,
                        "height_alignment": 480,
                        "vmem_flag": 31,
                        "buffer_nr": 10,
                        "priority": "high",
                        "source_filter": {
                            "filter_id": "dzoom_1",
                            "port_index": 0
                        }
                    },
                    {
                        "id": "raw_dump",
                        "type": "DCAM_STREAM_TYPE_COMMON",
                        "usage": "DCAM_STREAM_USAGE_STILL",
                        "behavior": "DCAM_STREAM_BEHAVIOR_REPEATING",
                        "format": "DUSS_PIXFMT_RAW16_OPAQUE",
                        "flag": [
                            "DCAM_STREAM_FLAG_ON_DEMAND"
                        ],
                        "fps": "DCAM_FPS_2397",
                        "width": 5472,
                        "height": 3648,
                        "width_alignment": 128,
                        "height_alignment": 1,
                        "buffer_nr": 2
                    }
                ]
            },
            {
                "id": "still_3x2_pano-cap",
                "shooter_id": "still-general",
                "shooter_param": "res=3x2_pano_cap;normal_cap=offline;",
                "still_raw_process_pipe": [
                    {
                        "id": "raw_process_pipe",
                        "nodes": [
                            {
                                "id": "input",
                                "param": ""
                            },
                            {
                                "id": "ob",
                                "param": "output_buffer_nr=2;dsp_cores=16;outstanding_mask=102261126;"
                            }
                        ]
                    }
                ],
                "still_process_pipe": [
                    {
                        "id": "comm_pipe",
                        "nodes": [
                            {
                                "id": "input",
                                "param": ""
                            },
                            {
                                "id": "tino",
                                "param": "output_buffer_nr=2;dsp_cores=20;outstanding_mask=102261126;"
                            }
                        ]
                    },
                    {
                        "id": "main_pipe",
                        "nodes": [
                            {
                                "id": "input",
                                "param": ""
                            }
                        ]
                    },
                    {
                        "id": "pano_pipe",
                        "nodes": [
                            {
                                "id": "input",
                                "param": ""
                            }
                        ]
                    }
                ],
                "sensor_fps": "DCAM_FPS_2997",
                "filters": [
                    {
                        "type": "dzoom",
                        "id": "dzoom_1",
                        "style": "pull",
                        "parameter": ""
                    },
                    {
                        "type": "disp_eng",
                        "id": "disp_eng_1",
                        "style": "listen",
                        "parameter": "name=wm232;"
                    }
                ],
                "streams": [
                    {
                        "id": "liveview",
                        "copy_from": "still_3x2/liveview"
                    },
                    {
                        "id": "still_yuv",
                        "copy_from": "still_3x2/still_yuv",
                        "buffer_nr": 4
                    },
                    {
                        "id": "still_raw",
                        "copy_from": "still_3x2/still_raw",
                        "buffer_nr": 4
                    },
                    {
                        "id": "navigation",
                        "copy_from": "still_3x2/navigation"
                    },
                    {
                        "id": "vision",
                        "copy_from": "still_3x2/vision"
                    }
                ]
            }

        ]
    }
}
