Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
References: <20191210175442.2975-1-vincentfu@gmail.com> <CALjAwxi-nfeunNEOuhbjF8L-0LhmmHZ=exRBAJ0V+EQi0ep37Q@mail.gmail.com>
 <191fa593-aecc-a077-c24f-980f6d8280e0@gmail.com> <cf608708-3aee-767b-7460-ae8e7d77cc7e@kernel.dk>
 <17299496-53a9-f02e-1726-e3b2c707db6c@gmail.com> <948efdcd-f039-25dd-0f1c-eee5671b1e6f@kernel.dk>
In-Reply-To: <948efdcd-f039-25dd-0f1c-eee5671b1e6f@kernel.dk>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 12 Dec 2019 08:37:06 +0000
Message-ID: <CALjAwxgHsLR-1-za4xQk24_npNDzQVP1LiA3HisiAQorRCi9dw@mail.gmail.com>
Subject: Re: [PATCH 0/9] testing patches
Content-Type: text/plain; charset="UTF-8"
To: Jens Axboe <axboe@kernel.dk>
Cc: Vincent Fu <vincentfu@gmail.com>, fio <fio@vger.kernel.org>, Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

On Thu, 12 Dec 2019 at 03:54, Jens Axboe <axboe@kernel.dk> wrote:
>
> On 12/11/19 1:10 PM, Vincent Fu wrote:
> > On 12/11/19 2:57 PM, Jens Axboe wrote:
> >> On 12/11/19 12:53 PM, Vincent Fu wrote:
> >>> On 12/10/19 4:32 PM, Sitsofe Wheeler wrote:
> >>>> On Tue, 10 Dec 2019 at 17:56, <vincentfu@gmail.com> wrote:
> >>>>>
> >>>>> From: Vincent Fu <vincent.fu@wdc.com>
> >>>>>
> >>>>> Jens, please consider this series of patches related to testing.
> >>>>>
> >>>>> The patches improve t/run-fio-tests.py in various ways, most prominently
> >>>>> adding support for Windows and macOS.
> >>>>>
> >>>>> Also included are travis and appveyor patches that add run-fio-tests.py
> >>>>> as a step.  Currently both the travis and appveyor build processes
> >>>>> complete in less than four minutes.  Adding run-fio-tests.py increases
> >>>>> this to about 20 minutes for travis and 14 minutes for appveyor.

<snip>

> Let's try this out and see how it goes. If it doesn't work so well, then
> we always have the option of slimming down the default run, or whatever
> else we can do to make it faster.

OK fair enough :-)

-- 
Sitsofe | http://sucs.org/~sits/

