Return-Path: <Eric.Lamkin@lsi.com>
From: "Lamkin, Eric" <Eric.Lamkin@lsi.com>
Subject: RE: fio replay
Date: Thu, 27 Feb 2014 20:12:57 +0000
Message-ID: <447915ba4f824078bed770cb1e95526c@BN1PR07MB437.namprd07.prod.outlook.com>
References: <651fd21aaf304da0b24902febae3c345@BN1PR07MB437.namprd07.prod.outlook.com>
 <76F46F78-8F5A-45CF-BBCE-3ADC63AFF541@nellans.org>
 <934f861a97f2443aa35296c2d6d8c848@BN1PR07MB437.namprd07.prod.outlook.com>
 <530E2933.2080903@kernel.dk> <530E6056.2020309@kernel.dk>
 <c79c5d2e1b3f4a3487815ca851a8399e@BN1PR07MB437.namprd07.prod.outlook.com>
 <530F887F.5050809@kernel.dk>
In-Reply-To: <530F887F.5050809@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Return-Path: Eric.Lamkin@lsi.com
To: Jens Axboe <axboe@kernel.dk>, David Nellans <david@nellans.org>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Jens,

I'm very appreciative that you and others are giving this time and consider=
ation.

For the replay host the OS is RHEL6.3.  (The originating host is RHEL6.4.)

[root@x3650M4 cache_stats]# uname -r
2.6.32-279.el6.x86_64

I've completed a new trace capture and replay using a single device.
The originating block trace encountered no dropped events this time.
I used fio 2.1.4 this time.
The replay once again stopped prematurely.

Here is the synopsis based on analysis of the block trace captured on the o=
riginating host to the block trace captured on the replay host.

I have another email to this thread with all the details that I will send u=
pon request.
I would postulate since others have had success with replay that the issue =
is with something I am doing vs a fio issue.
Just need help identifying what I need to do differently.  That is to say t=
hat running a different version of fio will likely result in the same issue=
 unless there are fixes in replay that map to what has been observed here. =
 I rather imagine that discovering my issue will involve someone well verse=
d in replay taking time to review my procedure and results (in the detailed=
 email not yet sent).

Comparative analysis replay to original
Capture time .88%
% reads +1.16%
% writes -1.16%
Block range 104%
Queue operations .78%
Blocks queued .78%
% sequential queued 108%
Max blocks per sequential run 31.4%
Completion operations 1.42%
Blocks completed .78%
% sequential completions 110%

Eric
-----Original Message-----
From: Jens Axboe [mailto:axboe@kernel.dk]=20
Sent: Thursday, February 27, 2014 12:49 PM
To: Lamkin, Eric; David Nellans
Cc: fio@vger.kernel.org
Subject: Re: fio replay

On 2014-02-26 13:55, Lamkin, Eric wrote:
> Jens,
>
> Sorry I don't know how to compile.
> Hope that doesn't mean no one will ever replay to me again.

It's pretty easy, basically boils down to doing:

$ git clone git://git.kernel.dk/fio
$ cd fio
$ make

and then run ./fio. What OS are you using?

--=20
Jens Axboe



