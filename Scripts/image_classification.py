#!/usr/bin/env python
import turicreate as tc
import os
import matplotlib.pyplot as plt

# Load train data
train_data = tc.image_analysis.load_images("../dataset/train", with_path=True)
train_data["label"] = train_data["path"].apply(lambda path: os.path.basename(os.path.split(path)[0]))
train_data.head()
len(train_data)

print(train_data["label"].summary())

# Load test data
test_data = tc.image_analysis.load_images("../dataset/test", with_path=True)
test_data["label"] = test_data["path"].apply(lambda path: os.path.basename(os.path.split(path)[0]))
print(test_data["label"].summary())

# Train
model_type = "squeezenet_v1.1"
model = tc.image_classifier.create(train_data, target="label", model=model_type, verbose=True, max_iterations=100)

print(model.summary())
print(model.classifier)
print(model.input_image_shape)
print(model.model)
print(model.classes)

# Evaluate
metrics = model.evaluate(train_data)
print(metrics["accuracy"])

metrics = model.evaluate(test_data)

for k, v in metrics.items():
    print(k, "\n", v)

print(metrics["confusion_matrix"])

predictions = model.predict(test_data)
print(predictions)

output = model.classify(test_data)
output.print_rows(num_rows=15, num_columns=2)

imgs_with_pred = test_data.add_columns(output)
imgs_with_pred.explore()

model.export_coreml("MyCarsBase.mlmodel")
