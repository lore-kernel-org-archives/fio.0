Return-Path: <andrey.v.kuzmin@gmail.com>
MIME-Version: 1.0
In-Reply-To: <55A912DB.8030306@kernel.dk>
References: <CANvN+ekBVCAMge-A9dMTeOnXSJ7sZ9OdQ_ZMeqgcTsoa8J0bJg@mail.gmail.com>
	<55A912DB.8030306@kernel.dk>
Date: Fri, 17 Jul 2015 17:53:34 +0300
Message-ID: <CANvN+en4p0q4Ff4n9KBLku5O67Cs68VUpp0qHK+ye2Cu4YbcJw@mail.gmail.com>
Subject: Re: PATCH: Don't lose pending completions on exit in time- or
 size-based job with asynchronous I/O engine
From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Content-Type: multipart/alternative; boundary=bcaec53f37472bdfbf051b135a11
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

--bcaec53f37472bdfbf051b135a11
Content-Type: text/plain; charset=UTF-8

On Jul 17, 2015 5:36 PM, "Jens Axboe" <axboe@kernel.dk> wrote:
>
> On 07/17/2015 08:30 AM, Andrey Kuzmin wrote:
>>
>> Probably worth adding to do_verify() as well.
>
>
> Might be better to ensure that they are reaped when we break out of the
loop instead?
>

That's exactly what happens with the patch, doesn't it?
> --
> Jens Axboe
>

--bcaec53f37472bdfbf051b135a11
Content-Type: text/html; charset=UTF-8

<p dir="ltr"><br>
On Jul 17, 2015 5:36 PM, &quot;Jens Axboe&quot; &lt;<a href="mailto:axboe@kernel.dk">axboe@kernel.dk</a>&gt; wrote:<br>
&gt;<br>
&gt; On 07/17/2015 08:30 AM, Andrey Kuzmin wrote:<br>
&gt;&gt;<br>
&gt;&gt; Probably worth adding to do_verify() as well.<br>
&gt;<br>
&gt;<br>
&gt; Might be better to ensure that they are reaped when we break out of the loop instead?<br>
&gt;</p>
<p dir="ltr">That&#39;s exactly what happens with the patch, doesn&#39;t it?<br>
&gt; -- <br>
&gt; Jens Axboe<br>
&gt;<br>
</p>

--bcaec53f37472bdfbf051b135a11--

