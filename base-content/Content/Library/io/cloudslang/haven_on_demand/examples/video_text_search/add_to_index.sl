####################################################
#!!
#! @description: Extracts text from a video and adds it to a Haven OnDemand index.
#! @input api_key: API key
#! @input file: local path to video file to be added to the index
#! @input title: title for video to be added to the index
#! @input url: YouTube url for the video
#! @input index: index to add the extracted text to
#! @input proxy_host: proxy server
#!                    optional
#! @input proxy_port: proxy server port
#!                    optional
#! @output error_message: error message if one exists, empty otherwise
#! @output return_result: result retured by Haven OnDemand upon adding item to the index
#!!#
####################################################

namespace: io.cloudslang.haven_on_demand.examples.video_text_search
imports:
  hod: io.cloudslang.haven_on_demand
  utils: io.cloudslang.base.http
flow:
  name: add_to_index
  inputs:
    - api_key:
        sensitive: true
    - file
    - title
    - url
    - index
    - proxy_host:
        required: false
    - proxy_port:
        required: false
  workflow:
    - get_transcript:
        do:
          hod.speech_recognition.process_video:
            - api_key
            - file
            - interval: '0'
            - proxy_host
            - proxy_port
        publish:
          - return_result
          - error_message
        navigate:
          - SUCCESS: build_index_item
          - FAILURE: on_failure
    - build_index_item:
        do:
          hod.examples.video_text_search.build_index_item:
            - json_input: '${return_result}'
            - title
            - url
        publish:
          - json_index_item
        navigate:
          - SUCCESS: encode_json
          - FAILURE: on_failure
    - encode_json:
        do:
          utils.url_encoder:
            - data: '${json_index_item}'
            - quote_plus: 'true'
        publish:
          - encoded_json: '${result}'
        navigate:
          - SUCCESS: add_to_index
          - FAILURE: on_failure
    - add_to_index:
        do:
          hod.unstructured_text_indexing.add_to_text_index:
            - api_key
            - json: '${encoded_json}'
            - index
            - proxy_host
            - proxy_port
        publish:
          - error_message
          - return_result
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - error_message
    - return_result
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      get_transcript:
        x: 344
        y: 37
      build_index_item:
        x: 168
        y: 157
      encode_json:
        x: 514
        y: 58
      add_to_index:
        x: 1000
        y: 150
        navigate:
          993d7314-3d60-6a41-58fa-ddd3f00e224f:
            targetId: 346e5e51-aa49-d3fd-9453-edc440e18ba9
            port: SUCCESS
    results:
      SUCCESS:
        346e5e51-aa49-d3fd-9453-edc440e18ba9:
          x: 1300
          y: 150
