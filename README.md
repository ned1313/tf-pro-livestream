# Terraform Authoring and Operations Pro Exam Prep

This is the repository supporting the weekly livestream on the [Ned in the Cloud YouTube channel](https://www.youtube.com/@NedintheCloud) covering the objectives of the Terraform Pro exam.

![TF Pro Thumbnail](.\TerraformProExamPrep.png)

Each livestream will include an agenda and link to the livestream.

## Table of Contents

| Session | Summary |
|---------|---------|
| [2026-04-02 Notes](#2026-04-02-notes) | Kick-off stream covering terraform init, workspaces, and the exam format |
| [2026-04-02 Notes](#2026-04-02-notes-1) | Deep dive into terraform plan, apply, and destroy commands |

## 2026-04-02 Notes

[First stream y'all!](https://www.youtube.com/live/OPGNAUotKlk)

### Agenda

* What the livestream is meant to cover
  * We are here to discuss and study topics related to the Terraform Authoring and Operations Professional exam
* Ground rules and community notes
  * I cannot tell you exactly what is on the exam
  * I cannot discuss actual exam questions or scenarios
  * Community rules from HUGs are in effect (don't be an asshat)
  * Feel free to ask questions at any time!
  * I don't have prepared examples; we can build together!
* Review the exam objectives
  * Six objectives - [List of objectives](https://developer.hashicorp.com/terraform/tutorials/pro-cert/pro-review)
    1. Manage resource lifecycle
    2. Develop & troubleshoot dynamic configuration
    3. Develop collaborative Terraform workflows
    4. Create, maintain, and use Terraform modules
    5. Configure and use Terraform providers
    6. Collaborate on infrastructure as code using HCP Terraform (**multiple-choice only**)
* Describe the exam taking experience
  * Sign up through cert portal
  * You have 4 hours and one break
  * Signed in through a browser to a remote environment
  * You can use VS Code, vim, or nano
  * You'll have terminal access too
  * Current exam is based on AWS, Azure coming very soon
  * Read the directions carefully! There's a lot of important info in there
  * Paste with ctrl-alt-v
* Start discussion of the first topic
  * I don't expect to get through all the sub-topics today
  * We can start with terraform init

### What we covered

* Talked about terraform init and all its various options
* Dug into terraform workspaces and how they differ from HCP Terraform workspaces
* Discussed the exam format, when Azure version is coming, and questions about the exam environment
* Built an example configuration in init-example to demonstrate various init options

## 2026-04-02 Notes

[Second stream](https://www.youtube.com/live/Epi3X0riDm4)

### Agenda

* Introduce topics for today
* Terraform Plan and it's options
  * What does terraform plan actually do?
  * Starts by validating the config (valid code, provider constraints, etc.)
  * Begins rendering configuration
    * Build dependency graph
    * Check on variable inputs
  * Loads state from persistent storage
  * Performs a state refresh for all resources and data sources
  * Walks graph to do comparison
    * Object in config? Compare to state
    * Object only in state? Remove
  * Execute pre-conditions before resource eval (if possible)
  * Execute post-conditions after resource eval (if possible)
  * Run checks if possible
  * Produce human readable execution plan
  * Save execution plan to file (if desired)
* What does terraform apply actually do?
  * Produces a plan if there isn't one
  * Verifies a plan if one is provided
  * Loads state and starts making changes
  * Completed changes are committed to state
  * Pre and post conditions are run
  * Check blocks are executed
  * Updated state is written back to the backend
* What about terraform destroy?
  * It's just an alias!

### What We Covered

We covered topics 1b-1d around the `terraform plan` and `terraform apply` commands.

The `plan-example` configuration was used to demonstrate the various plan and apply options.

We also learned that `terraform plan` checks for variable values BEFORE running a validate.

And we learned that Windows doesn't love using just `tfplan` for a plan file name. I blame Copilot.