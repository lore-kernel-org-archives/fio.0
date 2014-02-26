Return-Path: <Eric.Lamkin@lsi.com>
From: "Lamkin, Eric" <Eric.Lamkin@lsi.com>
Subject: RE: fio replay
Date: Wed, 26 Feb 2014 21:55:08 +0000
Message-ID: <c79c5d2e1b3f4a3487815ca851a8399e@BN1PR07MB437.namprd07.prod.outlook.com>
References: <651fd21aaf304da0b24902febae3c345@BN1PR07MB437.namprd07.prod.outlook.com>
 <76F46F78-8F5A-45CF-BBCE-3ADC63AFF541@nellans.org>
 <934f861a97f2443aa35296c2d6d8c848@BN1PR07MB437.namprd07.prod.outlook.com>
 <530E2933.2080903@kernel.dk> <530E6056.2020309@kernel.dk>
In-Reply-To: <530E6056.2020309@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, David Nellans <david@nellans.org>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Jens,

Sorry I don't know how to compile.
Hope that doesn't mean no one will ever replay to me again.

I'm very appreciative of the suggestions you've made and will try capturing=
 a source trace where I don't get any dropped event messages.  I'll also ca=
pture just one device.

My blktrace log files go to the OS storage device whereas the devices trace=
d are on a different storage path.

In this first experiment I didn't have to do any device mapping as I was ab=
le to arrange storage on the replay host of sufficient capacity with matchi=
ng device references.

Eric
-----Original Message-----
From: Jens Axboe [mailto:axboe@kernel.dk]=20
Sent: Wednesday, February 26, 2014 3:45 PM
To: Lamkin, Eric; David Nellans
Cc: fio@vger.kernel.org
Subject: Re: fio replay

On 2014-02-26 09:49, Jens Axboe wrote:
> On 2014-02-26 06:23, Lamkin, Eric wrote:
>> David,
>>
>> Thanks for responding.
>> I sent the below out last week but didn't get a reply so thought I'd=20
>> try a simpler 'what works' tactic this morning.
>> As seen in the below I'm using 2.0.10.
>
> I just ran a quick test here, current -git seems to work fine for me.=20
> It might be a bit finicky in that the error handling isn't stellar,=20
> which I'm thinking could be your issue since you have dropped events=20
> in your blktraces. You need to eliminate any dropped events - either=20
> log to tmpfs or send the traces over the network, that would likely do it=
.
>
> If that doesn't solve it for you, please boil this down to a smaller=20
> test case. Start with one device. Does that work? Up the complexity=20
> until you see an issue, then I can likely help you get this fixed if I=20
> get the problematic trace.

Can you try current -git? I made some improvements/fixes to the multiple de=
vice handling.

--
Jens Axboe



