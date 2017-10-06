---
layout: post
date:   2017-04-06 12:00:00
categories: bi
---
* will be replace by toc
{:toc}

# The Dataflow Model for data processing

http://www.vldb.org/pvldb/vol8/p1792-Akidau.pdf

## Abstract

We must choose appropriate tradeoffs along the axes of interest:
- correctness
- latency
- cost.

Data Flow Model 
- Semanics ( meaning ) it enables
- core principles
- model validity

## 1. Introduction

- MapReduce [16] and its successors(  Hadoop [4], Pig [18], Hive [29], Spark [33] )
- SQL community (e.g. query systems [1, 14, 15], windowing [22], data streams [24], time domains [28], semantic models [9])
- low-latency processing such as Spark Streaming[34], MillWheel, and Storm [5]

- Batch systems suffer from the latency problems inherent with collecting all input data into a batch before processing it.
- For many streaming systems, it is unclear how they would remain fault-tolerant at scale
- Those that provide scalability and fault-tolerance fall short on expressiveness or correctness vectors
- Lambda Architecture [25] systems can achieve many of the desired requirements

Dataflow Model:
- What results are being computed.
- Where in event time they are being computed.
- When in processing time they are materialized.
- How earlier results relate to later refinements.

Defines:
- windowing model which supports unaligned event time windows, and a simple API for their creation and use
- A triggering model that binds the output times of results to runtime characteristics of the pipeline, with a powerful and flexible declarative API for describing desired triggering semantics
- incremental processing model that integrates retractions and updates into the windowing and triggering models described above
- Scalable implementations of the above atop the MillWheel streaming engine and the FlumeJava batch engine, with an external reimplementation for Google Cloud Dataflow, including an open-source SDK [19] that is runtime-agnostic
- A set of core principles that guided the design of this model

## 1.1 Unbounded/Bounded vs Streaming/Batch
When describing infinite/finite data sets, we prefer the terms unbounded/bounded over streaming/batch.
From the perspective of the model, the distinction of streaming or batch is largely irrelevant (runtime execution engines)

## 1.2 Windowing
Windowing [22] slices up a dataset into finite chunks for processing as a group.
Windowing is effectively always time based.
Eg. fixed ( one day of data, one after another), sliding (one day of data at each hour), session ( process one session data at one moment )

## 1.3 Time Domain

- Event Time, which is the time at which the event itself actually occurred
- Processing Time, which is the time at which an event is observed at any given point during processing within the pipeline, i.e. the current time according to the system clock

# 2. DATAFLOW MODEL

## 2.1 Core Primitives
The Dataflow SDK has two core transforms that operate on the (key, value) pairs flowing through the system.
- ParDo for generic parallel processing. 
Each input element to be processed is provided to a user-defined function.
- GroupByKey for key-grouping (key, value) pairs.

## 2.2 Windowing

Systems which support grouping typically redefine their GroupByKey operation to essentially be GroupByKeyAndWindow.
- Set<Window> AssignWindows(T datum)
- Set<Window> MergeWindows(Set<Window> windows)

To support event-time windowing natively, instead of passing (key, value) pairs through the system, we now pass (key, value, event time, window) 4-tuples
eg. (k, v1, 12:00, [11:59, 12:01))

### 2.2.1 Window Assignment

### 2.2.2 Window Merging

## 2.3 Triggers & Incremental Processing

Triggers are a mechanism for stimulating the production of GroupByKeyAndWindow:
- Windowing determines where in event time data are grouped together for processing.
- Triggering determines when in processing time the results of groupings are emitted as panes.

Triggers system provides a way to control how multiple panes for the same window relate to each other, via three different refinement modes:
- Discarding: Upon triggering, window contents are discarded, and later results bear no relation to previous results.
- Accumulating: Upon triggering, window contents are left intact in persistent state, and later results become a refinement of previous results.
- Accumulating & Retracting: Upon triggering, in addition to the Accumulating semantics, a copy of the emitted value is also stored in persistent state. 
When the window triggers again in the future, a retraction for the previous value will be emitted first, followed by the new value as a normal datum.

# 3. IMPLEMENTATION & DESIGN

## 3.2 Design Principles

- Never rely on any notion of completeness.
- Be flexible, to accommodate the diversity of known use cases, and those to come in the future.
- Not only make sense, but also add value, in the context of each of the envisioned execution engines.
- Encourage clarity of implementation.
- Support robust analysis of data in the context in which they occurred.


## Glossary

- windowing = slicing data into finite chunks for processing. 
- low watermark = ~ min ( event time in windows, low watermark of other producers )