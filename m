Return-Path: <Vincent.Fu@sandisk.com>
From: Vincent Fu <Vincent.Fu@sandisk.com>
Subject: Re: terminating fio jobs upon reaching steady state
Date: Tue, 12 Jul 2016 21:50:50 +0000
Message-ID: <CY1PR0201MB18826AA731A7D9862BB848E18C300@CY1PR0201MB1882.namprd02.prod.outlook.com>
References: <CY1PR0201MB1882D39478B9483993B429488C240@CY1PR0201MB1882.namprd02.prod.outlook.com>
 <57854B1F.1000106@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2016-7-12 3:55 PM, Jens Axboe wrote:
> On 06/30/2016 08:49 AM, Vincent Fu wrote:
>> Jens, I have been working on a patch to give fio the ability to
>> terminate a job when steady state is attained. I have a crude
>> implementation that is working at
>> https://bitbucket.org/vincentfu/fio/commits/all but I'm hoping to
>> receive some feedback on its design.
>>
>> Currently, the feature works via helper_thread_main(). It collects data
>> in a ring buffer for a specified duration and carries out the
>> termination test when the ring buffer is full. If the test passes, the
>> job terminates. If the test fails, the job continues, the oldest data
>> point in the buffer is dropped, a new data point is added, and the
>> termination test is carried out again. The cycle repeats until the job
>> terminates because steady state was attained or for other reasons.
> Vincent, where are we at on this? Would be nice to get this included. A
> few comments:
I have a tweak for the JSON output to make, and I'm still a bit troubled
by the absence of a couple features (latency data for the steady state
period, BW/IOPS sequence for the entire run), but maybe those are tasks
to work on later.
> - The global 'steadystate' bool. Seems like this should be a per-job
> thing, and not global. For a specific group of threads, whether we are
> in steady state or not should be checked for those td's.
I set it as a global to avoid iterating over all the td's if a user is
just running a normal job and steadystate testing is not engaged at all,
but it's easy enough to make this a per-job variable.
> - Should still work with ramptime. If we're in ramp time, no checking.
> Start steady state checking once we are out of ramp time.
I do have one question about this. Suppose steady state detection and
group_reporting are enabled with 2 jobs:
job 0: ramp time =3D 10s
job 1: ramp time =3D 60s
What if job 0 reaches steady state before job 1's ramp time elapses? I
think the appropriate thing to do is to terminate all the jobs even
though job 1 is still in its ramp time. Does this sound reasonable to you?
> - Would be nice if the SS output was there for non-json. At least
> something for the normal output, I think we can safely ignore the
> terse/csv in this regard.
Ok. I will add this.
> - Should struct steady_state just be embedded in the thread_stat? It
> needs to be transmitted across the wire for client/server. So either you
> need to split it in two, or you need to embed it and sanitize it for
> on-the-wire transmission. You could keep the td->ss, and have a version
> that we export and embed that in thread_stat? If you do that, then have
> a steady_state_bla that's embedded in both struct steady_state and
> struct thread_stat.
I might need more direction from you to understand the implications of
the different choices but I will study this some more.

Thanks for the feedback.

Vincent


--
Vincent Fu
Software Dev Engr II
SanDisk | a Western Digital brand
Remote Worker, Rockville, MD, USA
T: 801 987 7079
Vincent.Fu@SanDisk.com

PLEASE NOTE: The information contained in this electronic mail message is i=
ntended only for the use of the designated recipient(s) named above. If the=
 reader of this message is not the intended recipient, you are hereby notif=
ied that you have received this message in error and that any review, disse=
mination, distribution, or copying of this message is strictly prohibited. =
If you have received this communication in error, please notify the sender =
by telephone or e-mail (as shown above) immediately and destroy any and all=
 copies of this message in your possession (whether hard copies or electron=
ically stored copies).

