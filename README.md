# YouTube-8M-Bowen

## Table of Contents
* [Using Frame-Level Features](#using-frame-level-features)
* [Using Audio Features](#using-audio-features)
* [Ground-Truth Label Files](#ground-truth-label-files)
* [Accessing Files on Google Cloud](#accessing-files-on-google-cloud)
* [Overview of Models](#overview-of-models)
   * [Video-Level Models](#video-level-models)
   * [Frame-Level Models](#frame-level-models)
* [Create Your Own Dataset Files](#create-your-own-dataset-files)
* [Overview of Files](#overview-of-files)
   * [Training](#training)
   * [Evaluation](#evaluation)
   * [Inference](#inference)
   * [Misc](#misc)
* [Training without this Starter Code](#training-without-this-starter-code)


If you would like to be considered for the prize, then your model checkpoint must be under 1
Gigabyte. We ask all competitors to
upload their model files (only the graph and checkpoint, without code) as we
want to verify that their model is small. You can bundle your model in a `.tgz`
file by passing the `--output_model_tgz` flag. For example
```
python inference.py --train_dir ~/yt8m/v2/models/video/sample_model  --output_file=kaggle_solution.csv --input_data_pattern=${HOME}/yt8m/v2/video/test*.tfrecord --output_model_tgz=my_model.tgz
```
then upload `my_model.tgz` to Kaggle via Team Model Upload. 

#### Train Frame-level model
Train using `train.py`, selecting a frame-level model (e.g.
`FrameLevelLogisticModel`), and instructing the trainer to use
`--frame_features`. TLDR - frame-level features are compressed, and this flag
uncompresses them.
```
python train.py --train_data_pattern="gs://youtube8m-ml-us-east1/2/frame/train/train*.tfrecord,gs://youtube8m-ml-us-east1/2/frame/validate/validate*.tfrecord" --model=NetVLADModelLF --train_dir ~/yt8m/v2/models/frame/NetVLADModelLF --frame_features --feature_names='rgb,audio' --feature_sizes='1024,128' --batch_size=80 --base_learning_rate=0.0002 --netvlad_cluster_size=256 --netvlad_hidden_size=1024 --moe_l2=1e-6 --iterations=300 --learning_rate_decay=0.8 --netvlad_relu=False --gating=True --moe_prob_gating=True --max_step=300000 --export_model_steps=3000

```

Evaluate the model
```
python eval.py --eval_data_pattern="gs://youtube8m-ml-us-east1/2/frame/validate/validate*.tfrecord" --train_dir ~/yt8m/v2/models/frame/NetVLADModelLF1 --frame_features --feature_names='rgb,audio' --feature_sizes='1024,128' --batch_size=1024 --base_learning_rate=0.0002 --netvlad_cluster_size=256 --netvlad_hidden_size=1024 --moe_l2=1e-6 --iterations=300 --learning_rate_decay=0.8 --netvlad_relu=False --gating=True --moe_prob_gating=True
```

Produce CSV (`kaggle_solution.csv`) by doing inference:
```

python inference.py --train_dir ~/yt8m/v2/models/frame/NetVLADModelLF1 --output_file=kaggle_solution.csv --input_data_pattern="gs://youtube8m-ml-us-east1/2/frame/test/test*.tfrecord" --batch_size=1024 --frame_features --feature_names='rgb,audio' --feature_sizes='1024,128' --base_learning_rate=0.0002 --netvlad_cluster_size=256 --netvlad_hidden_size=1024 --moe_l2=1e-6 --iterations=300 --learning_rate_decay=0.8 --netvlad_relu=False --gating=True --moe_prob_gating=True --run_once=True --top_k=50 --output_model_tgz=my_model.tgz
```
Similar to above, you can tar your model by appending flag
`--output_model_tgz=my_model.tgz`.

### Tensorboard

You can use Tensorboard to compare your frame-level or video-level models, like:

```sh
tensorboard --logdir frame:C:/Users/utbow/yt8m/v2/models/frame,video:C:/Users/utbow/yt8m/v2/models/video
```
We find it useful to keep the tensorboard instance always running, as we train
and evaluate different models.

### Training Details

The binaries `train.py`, `evaluate.py`, and `inference.py` use the flag
`--train_dir`. The `train.py` outputs to `--train_dir` the  TensorFlow graph as
well as the model checkpoint, as the model is training. It will also output a
JSON file, `model_flags.json`, which is used by `evaluate.py` and `inference.py`
to setup the model and know what type of data to feed (frame-level VS
video-level, as determined by the flags passed to `train.py`).

You can specify a model by using the `--model` flag. For example, you can
utilize the `LogisticModel` (the default) by:

```sh
YT8M_DIR=~/yt8m/v2
python train.py --train_data_pattern=${YT8M_DIR}/v2/video/train*.tfrecord --model=LogisticModel --train_dir ~/yt8m/v2/models/logistic
```

Since the dataset is sharded into 3844 individual files, we use a wildcard (\*)
to represent all of those files.

By default, the training code will frequently write _checkpoint_ files (i.e.
values of all trainable parameters, at the current training iteration). These
will be written to the `--train_dir`. If you re-use a `--train_dir`, the trainer
will first restore the latest checkpoint written in that directory. This only
works if the architecture of the checkpoint matches the graph created by the
training code. If you are in active development/debugging phase, consider
adding `--start_new_model` flag to your run configuration.

### Evaluation and Inference

To evaluate the model, run

```sh
python eval.py --eval_data_pattern=${YT8M_DIR}/v2/video/validate*.tfrecord --train_dir ~/yt8m/v2/models/logistic --run_once=True
```

When you are happy with your model, you can generate a csv file of predictions
from it by running

```sh
python inference.py --output_file predictions.csv --input_data_pattern=${YT8M_DIR}/v2/video/test*.tfrecord' --train_dir ~/yt8m/v2/models/logistic
```

This will output the top 20 predicted labels from the model for every example
to `predictions.csv`.

### Using Frame-Level Features

Follow the same instructions as above, appending
`--frame_features=True --model=FrameLevelLogisticModel --feature_names="rgb"
--feature_sizes="1024"` for `train.py` and changing `--train_dir`.

The `FrameLevelLogisticModel` is designed to provide equivalent results to a
logistic model trained over the video-level features. Please look at the
`models.py` file to see how to implement your own models.

### Using Audio Features
```
--feature_names="rgb,audio" --feature_sizes="1024,128"
```

**NOTE:** Make sure the set of features and the order in which the appear in the
lists provided to the two flags above match.

### Ground-Truth Label Files

We also provide CSV files containing the ground-truth label information of the
'train' and 'validation' partitions of the dataset. These files can be
downloaded using 'gsutil' command:

```
gsutil cp gs://us.data.yt8m.org/2/ground_truth_labels/train_labels.csv /destination/folder/
gsutil cp gs://us.data.yt8m.org/2/ground_truth_labels/validate_labels.csv /destination/folder/
```

or directly using the following links:

*   [http://us.data.yt8m.org/2/ground_truth_labels/train_labels.csv](http://us.data.yt8m.org/2/ground_truth_labels/train_labels.csv)
*   [http://us.data.yt8m.org/2/ground_truth_labels/validate_labels.csv](http://us.data.yt8m.org/2/ground_truth_labels/validate_labels.csv)

Each line in the files starts with the video id and is followed by the list of
ground-truth labels corresponding to that video. For example, for a video with
id 'VIDEO_ID' and two labels 'LABEL1' and 'LABEL2' we store the following line:

```
VIDEO_ID,LABEL1 LABEL2
```


You can train many jobs at once and use tensorboard to compare their performance
visually.

```sh
tensorboard --logdir=$BUCKET_NAME --port=8080
```

Once tensorboard is running, you can access it at the following url:
[http://localhost:8080](http://localhost:8080).
If you are using Google Cloud Shell, you can instead click the Web Preview button
on the upper left corner of the Cloud Shell window and select "Preview on port 8080".
This will bring up a new browser tab with the Tensorboard view.

### Evaluation and Inference
Here's how to evaluate a model on the validation dataset:

```sh
JOB_TO_EVAL=yt8m_train_video_level_logistic_model
JOB_NAME=yt8m_eval_$(date +%Y%m%d_%H%M%S); gcloud --verbosity=debug ml-engine jobs \
submit training $JOB_NAME \
--package-path=youtube-8m --module-name=youtube-8m.eval \
--staging-bucket=$BUCKET_NAME --region=us-east1 \
--config=youtube-8m/cloudml-gpu.yaml \
-- --eval_data_pattern='gs://youtube8m-ml-us-east1/2/video/validate/validate*.tfrecord' \
--model=LogisticModel \
--train_dir=$BUCKET_NAME/${JOB_TO_EVAL} --run_once=True
```

And here's how to perform inference with a model on the test set:

```sh
JOB_TO_EVAL=yt8m_train_video_level_logistic_model
JOB_NAME=yt8m_inference_$(date +%Y%m%d_%H%M%S); gcloud --verbosity=debug ml-engine jobs \
submit training $JOB_NAME \
--package-path=youtube-8m --module-name=youtube-8m.inference \
--staging-bucket=$BUCKET_NAME --region=us-east1 \
--config=youtube-8m/cloudml-gpu.yaml \
-- --input_data_pattern='gs://youtube8m-ml/2/video/test/test*.tfrecord' \
--train_dir=$BUCKET_NAME/${JOB_TO_EVAL} \
--output_file=$BUCKET_NAME/${JOB_TO_EVAL}/predictions.csv
```

Note the confusing use of 'training' in the above gcloud commands. Despite the
name, the 'training' argument really just offers a cloud hosted
python/tensorflow service. From the point of view of the Cloud Platform, there
is no distinction between our training and inference jobs. The Cloud ML platform
also offers specialized functionality for prediction with
Tensorflow models, but discussing that is beyond the scope of this readme.

Once these job starts executing you will see outputs similar to the
following for the evaluation code:

```
examples_processed: 1024 | global_step 447044 | Batch Hit@1: 0.782 | Batch PERR: 0.637 | Batch Loss: 7.821 | Examples_per_sec: 834.658
```

and the following for the inference code:

```
num examples processed: 8192 elapsed seconds: 14.85
```

### Accessing Files on Google Cloud

You can browse the storage buckets you created on Google Cloud, for example, to
access the trained models, prediction CSV files, etc. by visiting the
[Google Cloud storage browser](https://console.cloud.google.com/storage/browser).

Alternatively, you can use the 'gsutil' command to download the files directly.
For example, to download the output of the inference code from the previous
section to your local machine, run:


```
gsutil cp $BUCKET_NAME/${JOB_TO_EVAL}/predictions.csv .
```

### Using Frame-Level Features

Append
```sh
--frame_features=True --model=FrameLevelLogisticModel --feature_names="rgb" \
--feature_sizes="1024" --batch_size=128 \
--train_dir=$BUCKET_NAME/yt8m_train_frame_level_logistic_model
```

to the 'gcloud' training command given above, and change 'video' in paths to
'frame'. Here is a sample command to kick-off a frame-level job:

```sh
JOB_NAME=yt8m_train_$(date +%Y%m%d_%H%M%S); gcloud --verbosity=debug ml-engine jobs \
submit training $JOB_NAME \
--package-path=youtube-8m --module-name=youtube-8m.train \
--staging-bucket=$BUCKET_NAME --region=us-east1 \
--config=youtube-8m/cloudml-gpu.yaml \
-- --train_data_pattern='gs://youtube8m-ml-us-east1/1/frame_level/train/train*.tfrecord' \
--frame_features=True --model=FrameLevelLogisticModel --feature_names="rgb" \
--feature_sizes="1024" --batch_size=128 \
--train_dir=$BUCKET_NAME/yt8m_train_frame_level_logistic_model
```

The 'FrameLevelLogisticModel' is designed to provide equivalent results to a
logistic model trained over the video-level features. Please look at the
'video_level_models.py' or 'frame_level_models.py' files to see how to implement
your own models.


### Using Audio Features

The feature files (both Frame-Level and Video-Level) contain two sets of
features: 1) visual and 2) audio. The code defaults to using the visual
features only, but it is possible to use audio features instead of (or besides)
visual features. To specify the (combination of) features to use you must set
`--feature_names` and `--feature_sizes` flags. The visual and audio features are
called 'rgb' and 'audio' and have 1024 and 128 dimensions, respectively.
The two flags take a comma-separated list of values in string. For example, to
use audio-visual Video-Level features the flags must be set as follows:

```
--feature_names="mean_rgb,mean_audio" --feature_sizes="1024,128"
```

Similarly, to use audio-visual Frame-Level features use:

```
--feature_names="rgb,audio" --feature_sizes="1024,128"
```

**NOTE:** Make sure the set of features and the order in which the appear in the
lists provided to the two flags above match. Also, the order must match when
running training, evaluation, or inference.

### Using Larger Machine Types

Some complex frame-level models can take as long as a week to converge when
using only one GPU. You can train these models more quickly by using more
powerful machine types which have additional GPUs. To use a configuration with
4 GPUs, replace the argument to `--config` with `youtube-8m/cloudml-4gpu.yaml`.
Be careful with this argument as it will also increase the rate you are charged
by a factor of 4 as well.

## Overview of Models

This sample code contains implementations of the models given in the
[YouTube-8M technical report](https://arxiv.org/abs/1609.08675).

### Video-Level Models
*   `LogisticModel`: Linear projection of the output features into the label
                     space, followed by a sigmoid function to convert logit
                     values to probabilities.
*   `MoeModel`: A per-class softmax distribution over a configurable number of
                logistic classifiers. One of the classifiers in the mixture
                is not trained, and always predicts 0.

### Frame-Level Models
* `LstmModel`: Processes the features for each frame using a multi-layered
               LSTM neural net. The final internal state of the LSTM
               is input to a video-level model for classification. Note that
               you will need to change the learning rate to 0.001 when using
               this model.
* `DbofModel`: Projects the features for each frame into a higher dimensional
               'clustering' space, pools across frames in that space, and then
               uses a video-level model to classify the now aggregated features.
* `FrameLevelLogisticModel`: Equivalent to 'LogisticModel', but performs
                             average-pooling on the fly over frame-level
                             features rather than using pre-aggregated features.

## Create Your Own Dataset Files
You can create your dataset files from your own videos. Our
[feature extractor](./feature_extractor) code creates `tfrecord`
files, identical to our dataset files. You can use our starter code to train on
the `tfrecord` files output by the feature extractor. In addition, you can
fine-tune your YouTube-8M models on your new dataset.

## Overview of Files

### Training
*   `train.py`: The primary script for training models.
*   `losses.py`: Contains definitions for loss functions.
*   `models.py`: Contains the base class for defining a model.
*   `video_level_models.py`: Contains definitions for models that take
                             aggregated features as input.
*   `frame_level_models.py`: Contains definitions for models that take frame-
                             level features as input.
*   `model_util.py`: Contains functions that are of general utility for
                     implementing models.
*   `export_model.py`: Provides a class to export a model during training
                       for later use in batch prediction.
*   `readers.py`: Contains definitions for the Video dataset and Frame
                  dataset readers.

### Evaluation
*   `eval.py`: The primary script for evaluating models.
*   `eval_util.py`: Provides a class that calculates all evaluation metrics.
*   `average_precision_calculator.py`: Functions for calculating
                                       average precision.
*   `mean_average_precision_calculator.py`: Functions for calculating mean
                                            average precision.

### Inference
*   `inference.py`: Generates an output CSV file containing predictions of
                    the model over a set of videos. It optionally generates a
                    tarred file of the model.

### Misc
*   `README.md`: This documentation.
*   `utils.py`: Common functions.
*   `convert_prediction_from_json_to_csv.py`: Converts the JSON output of
        batch prediction into a CSV file for submission.

## Training without this Starter Code

You are welcome to use our dataset without using our starter code. However, if
you'd like to compete on Kaggle, then you must make sure that you are able to
produce a prediction CSV file, as well as a model `.tgz` file that match what
gets produced by our `inference.py`. In particular, the [predictions
CSV file](https://www.kaggle.com/c/youtube8m-2018#evaluation) 
must have two fields: `Id,Labels` where `Id` is stored as `id` in the each test
example and `Labels` is a space-delimited list of integer label IDs. The `.tgz`
must contain these 4 files at minumum:

* `model_flags.json`: a JSON file with keys `feature_sizes`, `frame_features`,
   and `feature_names`. These must be set to values that would match what can
   be set in `train.py`. For example, if your model is a frame-level model and
   expects vision and audio features (in that order), then the contents of
   `model_flags.json` can be:

       {"feature_sizes":"1024,128", "frame_features":true, "feature_names":"rgb,audio"}

* files `inference_model.data-00000-of-00001`, `inference_model.index`, and
  `inference_model.meta`, which should be loadable as a
  [TensorFlow
  MetaGraph](https://www.tensorflow.org/api_guides/python/meta_graph).

To verify that you correctly generated the `.tgz` file, run it with
inference.py:

```
python inference.py --input_model_tgz=/path/to/your.tgz --output_file=kaggle_solution.csv --input_data_pattern=${HOME}/yt8m/v2/video/test*.tfrecord
```

Make sure to replace `video` with `frame`, if your model is a frame-level model.

