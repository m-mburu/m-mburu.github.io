# Bootstrap article rewrite: voice, audience, and content plan

## Instructions to myself

This article is for the PhD candidate who has done an analysis but does not
have a strong statistics background, and for the manager who hears a
statistician say “we bootstrapped the results” during a presentation.

The aim is not to make the reader pass an examination on bootstrap methods.
The aim is to help the reader understand:

- why somebody would ask for a bootstrap;
- what the computer is doing when it bootstraps a result;
- what question a bootstrap confidence interval or test answers;
- what assumptions still matter;
- what the reader should ask when bootstrap results are presented.

Write as advice to a real person. Begin with a situation the reader may
recognize, then introduce the statistical problem. Do not begin with a formal
definition, a classification of bootstrap methods, or notation.

Use “you”, “we”, and “let us” naturally. The voice should sound like someone
sitting beside the reader and working through a problem with them.

Explain why each step is needed before showing code. After every important
table, number, or graph, say what it means in the language of the original
question.

Prefer headings that sound like questions or decisions:

- “Why is your supervisor asking for this?”
- “How can one sample pretend to be many samples?”
- “What should you report?”

Avoid headings that sound like a syllabus:

- “Introduction”
- “The two common bootstrap types”
- “Constructing bootstrap estimates”
- “Advanced bootstrap”

Introduce one new idea at a time. The reader should see a familiar statistical
test before seeing the bootstrap version of it.

Keep formulas out of the opening. Use a formula only after the reader already
understands the question it represents. When notation is necessary, translate
it immediately.

Do not place several interpretations in a dense bullet list after a large code
chunk. Break the analysis into short pieces:

1. the question;
2. the data;
3. the ordinary analysis;
4. the doubt or limitation;
5. the bootstrap;
6. the practical conclusion.

The code should support the story rather than become the story. Show a very
small resample by hand or in a small table before running thousands of
replicates in R.

Retain technical accuracy without using technical language too early. Terms
such as *sampling distribution*, *null distribution*, *studentized statistic*,
and *likelihood-ratio test* should appear only when the reader has an intuitive
picture to attach to them.

Do not present bootstrap as magic or as a method that removes all assumptions.
Explain that it can only learn from the sample it was given. A biased,
unrepresentative, dependent, or very small sample can be resampled thousands
of times and remain a poor foundation.

## What to learn from my earlier writing

The reference post is [The trend of Earth surface temperatures in Kenyan
towns](https://mmburublog.wordpress.com/2017/10/23/the-trend-of-earth-surface-temperatures-in-kenyan-towns/).

Useful habits from that post:

- It begins with a public question that matters before it discusses data.
- It quickly narrows a large subject to a concrete Kenyan example.
- It tells the reader what “we are going to do”.
- It moves in visible steps using phrases such as “The next step” and “Next we
  subset”.
- It explains the practical purpose of data preparation instead of merely
  listing operations.
- It returns to the real-world meaning after a graph rather than stopping at
  the statistical output.
- It uses direct, uncomplicated sentences and does not try to sound like a
  textbook.

Preserve that directness and curiosity. Improve the grammar, transitions, and
precision, but do not polish the prose until it loses the sense that a person
is thinking through a real problem with the reader.

## Central promise of the rewritten article

By the end of the first practical example, the reader should be able to say:

> A bootstrap repeatedly resamples the data I observed, recalculates the
> result, and uses the variation in those recalculated results to show how
> uncertain my original result is.

By the end of the article, the reader should also know that hypothesis testing
requires us to create a bootstrap world in which the null hypothesis is true.
That is different from simply resampling the original rows for a confidence
interval.

## Proposed opening

Begin with a scene, not a definition:

> Let us say you are a PhD candidate. You have spent months cleaning your data,
> fitting your model, and preparing the results. You show the results to your
> supervisors. One of them looks at a confidence interval and asks, “Did you
> bootstrap this?” Another says, “Carry out a bootstrap and see whether the
> conclusion remains the same.”
>
> You write the comment down, but perhaps you are not completely sure what they
> have asked you to do. Is bootstrap another statistical test? Is it a way of
> correcting a bad model? And why does a serious statistical method have the
> name of something attached to a boot?

Then make the same situation relevant to a non-technical manager:

> The same thing can happen in a meeting. A statistician says the confidence
> intervals were bootstrapped, everybody nods, and the presentation moves on.
> But what exactly should that word make you trust—or question—about the
> result?

## The short story behind the name

Tell the story in two or three paragraphs.

Baron Münchhausen is a fictional teller of impossible adventures. In one
version of the famous escape, he claims that he pulled himself and his horse
out of a swamp by pulling on his own hair. The later English expression “pull
yourself up by your own bootstraps” carries the same impossible idea: lifting
yourself without help from outside.

Connect the story immediately to the statistical problem:

> In statistics we normally want to know what would happen if we took many new
> samples from the population. The difficulty is that we usually have only one
> sample. Bootstrap asks that one sample to provide the repeated samples. It is
> our statistical attempt to pull more information out of the data using the
> data itself.

Be accurate about the history. Bradley Efron introduced the statistical
bootstrap in his 1979 paper, [“Bootstrap Methods: Another Look at the
Jackknife”](https://doi.org/10.1214/aos/1176344552). The original Münchhausen
tale involves his hair, not literal bootstraps; the bootstrap phrase is a later
version of the metaphor. The original stories are available through [Project
Gutenberg](https://www.gutenberg.org/ebooks/3154).

## First example: children’s weight-for-height z-scores

Use simulated weight-for-height z-scores (WHZ) because the example is connected
to a decision a public-health reader can understand.

Before doing any test, explain the measurement:

- A WHZ of 0 places a child at the WHO reference median for a child of the same
  height.
- A negative value means the child is lighter for their height than that
  reference.
- Wasting is defined for an individual child as WHZ below -2.

Use the [WHO child growth
standards](https://www.who.int/tools/child-growth-standards/standards/weight-for-length-height)
and the [WHO wasting
definition](https://www.who.int/data/gho/indicator-metadata-registry/imr-details/prevalence-of-malnutrition-%28weight-for-height-2-or--2-standard-deviation-from-the-median-of-the-who-child-growth-standards%29-among-children-under-5-years-of-age-by-type-%28wasting-and-overweight%29-%28sdg-2.2.2%29)
as the sources for this explanation.

### The first question

Use this as the simple mean question:

> Are children in this sample, on average, below the WHO reference for their
> weight relative to height?

Test:

- null hypothesis: the population mean WHZ is 0;
- alternative hypothesis: the population mean WHZ is below 0.

Do not call a mean below 0 “average wasting”. A group can have a negative mean
without its average being below the clinical wasting cut-off of -2.

If the article wants to ask whether the group mean itself is in the wasting
range, the reference value must be -2. That is a much stronger and less common
question:

- null hypothesis: the population mean WHZ is -2;
- alternative hypothesis: the population mean WHZ is below -2.

For the public-health question “How many children are wasted?”, calculate the
proportion with WHZ below -2. This is a different statistic and should later
receive its own bootstrap confidence interval.

### Show the ordinary test first

Simulate a small, plausible sample and show:

- the observed mean WHZ;
- a dot plot or histogram;
- the ordinary one-sample t-test;
- the conclusion in one sentence without statistical jargon.

For example:

> The sample mean is -0.7. This suggests that the children are lighter for
> their height than the WHO reference on average. The test asks whether a
> difference this large could reasonably arise if the population mean were
> actually 0.

Then introduce the doubt:

> The t-test obtains its answer from a known mathematical reference
> distribution. But what if your supervisor is not comfortable relying only on
> that approximation? Can we allow the observed data to show us how much the
> mean might vary?

## Build the bootstrap slowly

### One resample

Display perhaps 10 observed WHZ values. Draw 10 values from them with
replacement. Make duplicates visible.

Explain “with replacement” in ordinary language:

> After drawing a child’s value, we put it back before drawing again. The same
> value may therefore appear more than once, while another may not appear at
> all. That is expected.

Calculate the mean of this one resample.

### Many resamples

Repeat the process 5,000 times. Plot the 5,000 means.

Explain that the plot is an estimate of how the sample mean would move around
if the study could be repeated under similar conditions.

Use the distribution to show:

- a bootstrap standard error;
- a 95% confidence interval;
- a plain-language interpretation.

Only after this should the term *bootstrap distribution* be introduced.

## Bootstrap hypothesis test

Explain that ordinary resampling answers an uncertainty question but does not
automatically test a null hypothesis.

Use a simple analogy:

> If we want to judge the supervisor’s claim that the true mean might be 0, we
> must first create a world where 0 is true. We shift the observed WHZ values so
> that their mean is 0, then resample from those shifted values.

Then:

1. compute the observed test statistic;
2. centre the data so the null mean is true;
3. resample from the centred data;
4. calculate the test statistic each time;
5. count how often the null world produces a result at least as extreme as the
   observed result.

Show the classical and bootstrap p-values together, but make the conclusion
more prominent than the comparison of decimals.

## A second useful result: prevalence of wasting

Return to the distinction between a mean and a clinical classification.

Calculate the percentage of children with WHZ below -2, then bootstrap that
percentage to obtain a confidence interval.

This section makes the method useful to managers:

> The estimated prevalence may be 14%, but the bootstrap interval reminds us
> that another sample from the same population would not necessarily produce
> exactly 14%.

Mention survey design here. If the data came from a clustered or stratified
survey, resampling individual children as if they were independent may be
wrong. The resampling unit should respect how the sample was collected.

## Only now introduce the two main bootstrap families

Keep this section short.

### Nonparametric bootstrap

Resample the observed data. Describe it as letting the empirical data stand in
for the population.

### Parametric bootstrap

Fit a model and simulate new data from that model. Describe it as trusting the
fitted model enough to generate possible new datasets.

Use a small comparison table with:

- what is resampled or simulated;
- the main assumption;
- a common use;
- a question to ask before trusting it.

## What bootstrap cannot rescue

This should be a prominent practical section, not a footnote.

- It cannot correct a sample that systematically excluded important people.
- It cannot turn 15 observations into the information contained in 15,000
  independent observations.
- It cannot ignore clustering, repeated measurements, time order, or survey
  weights.
- It cannot make a badly specified parametric model correct.
- It does not remove the need to understand the data-generating process.

Use the line:

> Resampling a problem 5,000 times gives you 5,000 versions of the same
> problem.

## Keep the crab example, but move it later

The crab likelihood-ratio example can remain as an advanced case study after
the reader understands the basic idea. It should no longer carry the main
teaching burden.

Frame it as:

> The simple WHZ example bootstrapped a mean. Let us now see why the method
> becomes especially useful when the statistic is more complicated and the
> usual mathematical approximation may be doubtful.

Retain:

- the reduced and full Poisson models;
- the observed likelihood-ratio statistic;
- simulation under the reduced model;
- comparison of the classical and parametric-bootstrap p-values.

Move the permutation discussion to a separate note or clearly labelled
optional section. It introduces a different inferential method and can distract
from the central bootstrap explanation.

Move prediction intervals to a later article unless the final article remains
short enough. Confidence intervals, hypothesis tests, permutation tests,
likelihood-ratio tests, and prediction intervals are too many goals for the
opening article.

## Ending for the PhD student and manager

End with advice rather than a summary of definitions.

For the PhD student:

- What statistic did you bootstrap?
- What exactly did you resample?
- Did the resampling respect the study design?
- For a hypothesis test, how was the null hypothesis made true?
- How many replicates were used, and did increasing them change the result?
- Did the bootstrap and conventional analysis tell the same substantive story?

For the manager:

- What uncertainty is this interval describing?
- What assumptions were made?
- Does the sample represent the people or units we want to make decisions
  about?
- Would the decision change at the plausible lower or upper end of the
  interval?

Possible final paragraph:

> The next time a supervisor or statistician asks whether you bootstrapped the
> result, you do not need to hear it as an incantation. They are asking how
> stable your conclusion is when the observed data are made to play the role of
> many possible samples. Your next question should be: what did we resample,
> and did we resample it in a way that respects how the data were collected?

## Proposed article order

1. The supervisor and meeting-room problem.
2. Why the method has such a strange name.
3. The answer in one plain sentence.
4. A small simulated WHZ dataset.
5. The ordinary one-sample test.
6. One bootstrap sample by hand.
7. Five thousand bootstrap means.
8. A bootstrap confidence interval.
9. A bootstrap test under the null.
10. Mean WHZ versus prevalence of wasting.
11. Nonparametric versus parametric bootstrap.
12. What bootstrap cannot fix.
13. Optional advanced crab-model example.
14. Questions to ask when somebody presents a bootstrap result.

## Possible titles

- “Your Supervisor Said ‘Do a Bootstrap’. What Do They Mean?”
- “Bootstrap Without the Statistics Lecture”
- “What Does It Mean to Bootstrap a Result?”
- “One Sample, Many Possible Results: Understanding the Bootstrap”
- “Before You Bootstrap Your Results, Understand What You Are Asking”

The first title best matches the proposed opening and intended reader.
