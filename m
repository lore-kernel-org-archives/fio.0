Return-Path: <haghdoost@gmail.com>
MIME-Version: 1.0
In-Reply-To: <54ADC21F.10207@kernel.dk>
References: <54ADC21F.10207@kernel.dk>
From: Alireza Haghdoost <haghdoost@gmail.com>
Date: Thu, 8 Jan 2015 09:02:55 -0600
Message-ID: <CAB-428nDc67PJZ+imqBgqAqtgriCkkUJZNS6kO2xgYBGkgpcYg@mail.gmail.com>
Subject: Re: Non-uniform randomness with drifting
Content-Type: text/plain; charset=ISO-8859-1
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Wed, Jan 7, 2015 at 5:32 PM, Jens Axboe <axboe@kernel.dk> wrote:
> An example job file would contain:
>
> random_distribution=zipf
> random_drift=gradual
> random_drift_start_percentage=50
> random_drift_percentage=10

Jens,

This is an interesting proposal. Just to make sure if I understand
your example correctly, in this example you are proposing Gradual
shift  in hot/cold Blocks after 50% of workload is generated. This
shift then would be 10% total distribution for every 10% of remaining
workload access. It that correct ?

If I understand this correctly, the workload randomness distribution
would change after drift. For example if I start with zipf:1.2
initially, I would have different distribution after the drift which
is hard to describe. Would it be still Zipf with what theta parameter
?

Having said that, It would be more interesting and practical if we can
set specific distribution parameter for the drifted workload phases.
For example, Would be nice to divide the workload into 4 phases, phase
1: workload start with zipf:1.2, phase 2: workload drift to zipf:1.4,
phase 3: workload drift to pareto, phase 4:workload drift to uniform
distribution.

With this approach, we have more control on the workload randomness
distribution parameters for each gradual drift. Moreover, it would be
more practical to characterize a real workload and extract
distribution parameters for these phases and then feed them to fio for
synthetic re-generation of such a workload.


Hope it helps.
--
Alireza

