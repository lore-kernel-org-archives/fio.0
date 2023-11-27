Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AzyW5vAx"
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4DD3198
	for <fio@vger.kernel.org>; Mon, 27 Nov 2023 08:09:56 -0800 (PST)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-5cfc3a48ab2so13100177b3.0
        for <fio@vger.kernel.org>; Mon, 27 Nov 2023 08:09:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701101396; x=1701706196; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=1GMSjMClWqdussvBV6zKALRDOKkPqDWy3XUZ7BjawX8=;
        b=AzyW5vAxI+4frjCm57zMIW3JewQg+6LkQnFntf6HqVkGQwcLfYNtwZ6yDBkZKRDyi1
         8pV8X0mLH+eGLSLYdOT++5T4a6Xz3Ta4wEZR17+9CRgOIBMKWGGOvpcvWhELFa8TD22h
         akua+jvVMPem21VQWocfkIZsNY8++bc8ay5C5rV05eBZKhrrz5svayFPgeqU5t9iNI3L
         DdSLljuN7g55Q+mEPJAzZ2Vu40w8AT+YV4/fNCKH5b1ehW06zHH7lkMh+MpAx7EALkyO
         WRWU19sPJmTwObtM7knCSmy8PqVQh7o4rWfUfLvQlV3/+UM7/Ugpodf+gpIChKNINlSF
         FBYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701101396; x=1701706196;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1GMSjMClWqdussvBV6zKALRDOKkPqDWy3XUZ7BjawX8=;
        b=e6rg5H333Ioq8OiE9Oou09CumP3/EvCPzFrMDvrQ0lPThBlBww9OPrvEwLJCUN43Nf
         Y3HvdzpLRWDs4XquXxyDd4rvR+wpldkRDrUUmRZ9Xni4wgxJwhHcW7O01JOpuJLRLHa1
         tD9/wjQRyFQDqDA4aPbHw1Yzki7xp2M/pcJFStAcsf8Lcr/pli50OAB9nnvvmLPJEmEt
         MxTvQGR5m/mFwCLQjbHjkbbHe1qGS40KJ1WJZ9FF1zKHqaSrqal7htN/I+yFnQtLFyio
         is6BB40ZsJd6CaadB8wZe8UTAuyJZz+XwgmdkVoqncd2Al8K7g9X9aDQU1aBwcfhOHyf
         hmtg==
X-Gm-Message-State: AOJu0Yy0m5fkt5G43jACi2voG3uY1ATKAHV0IMVyxcHqh5V5TTH3Akzu
	sHSx6Bz8OwmSnkUflIOSoAosEvvOiRekUMedX+Rz1EW2DgY=
X-Google-Smtp-Source: AGHT+IHRceWVYXejAXPM933kXYiElAJwP+qiihRKMqR3uRt9bpQwATgxA//qji+7O7nOY1ZYkDh7gF9GOxlMobEbrlk=
X-Received: by 2002:a81:54c2:0:b0:5ca:e73e:6b98 with SMTP id
 i185-20020a8154c2000000b005cae73e6b98mr7864129ywb.38.1701101395787; Mon, 27
 Nov 2023 08:09:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Mark Smithers <smithersathpe@gmail.com>
Date: Mon, 27 Nov 2023 16:09:44 +0000
Message-ID: <CAM_M6akYhjNzHr=Ky7=XisZCneBRvTCOFtGU0ZeOWEB2mLWL2A@mail.gmail.com>
Subject: Summarizing output of multiple servers and threads.
To: fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

 When benchmarking my arrays I need to have multiple volumes presented
to multiple servers in order to get to saturation point. For example,
I may have 10 x 2TiB volumes presented to 3 servers for a total of 30
volumes. I need multiple servers as I run out of CPU power or I start
to block with queuing on the server HBAs This will then deliver
multiple millions of IOs if required.

Currently I use VDBench for testing, but I want to switch to using a
tool that is being maintained, plus there are several features in FIO
I would like to explore.

Because I use multiple servers, I run FIO in the client server mode
which seems fine. However, what I really miss is the results being
summarized into one file that tells me the results
My biggest struggle now is not in job creation but handling the results.

In VDBench, I get the following output for a single job/thread against
a single volume (so one file per thread or disk)

                interval        i/o   MB/sec   bytes   read     resp
  read    write     read    write     resp  queue  cpu%  cpu%
                               rate  1024**2     i/o    pct     time
  resp     resp      max      max   stddev  depth sys+u   sys
22:51:42.008           1   138447.1  1081.62    8192  29.94    1.762
 0.542    2.283    29.00    45.76    4.551  244.1  32.2   2.9
22:51:52.005           2   102852.8   803.54    8192  30.00    2.481
 0.427    3.362    24.45    46.83    5.956  255.1  34.0   4.5
22:52:02.006           3   103044.4   805.03    8192  30.10    2.475
 0.422    3.359    15.07    43.07    5.934  255.1  34.0   4.5
22:52:12.006           4   101983.1   796.74    8192  29.90    2.501
 0.423    3.388    15.56    48.09    6.067  255.1  33.9   4.5
22:52:22.006           5   102079.5   797.50    8192  30.05    2.500
 0.418    3.395    20.43    41.22    6.030  255.1  33.9   4.4
22:52:32.008           6   102795.2   803.09    8192  30.04    2.482
 0.426    3.364    20.89    48.04    5.973  255.1  34.0   4.5
22:52:42.007           7   102271.3   798.99    8192  29.93    2.495
 0.424    3.379    22.18    48.33    5.989  255.1  33.9   4.4
22:52:42.023     avg_2-7   102504.4   800.82    8192  30.00    2.489
 0.423    3.374    24.45    48.33    5.991  255.1  34.0   4.5

Which can result in a summary file like this of all the jobs/threads
that were being run.

                interval        i/o   MB/sec   bytes   read     resp
  read    write     read    write     resp  queue  cpu%  cpu%
                               rate  1024**2     i/o    pct     time
  resp     resp      max      max   stddev  depth sys+u   sys
22:51:42.036           1   849767.7  6638.81    8192  29.98    1.724
 0.535    2.233    31.37    46.26    4.510 1466.4  10.7   2.3
22:51:52.016           2   624072.8  4875.57    8192  29.97    2.455
 0.420    3.327    25.40    46.94    5.934 1531.8  11.8   3.4
22:52:02.017           3   623773.3  4873.23    8192  30.02    2.455
 0.416    3.330    19.12    43.11    5.921 1532.0  11.8   3.4
22:52:12.017           4   617948.9  4827.73    8192  29.95    2.478
 0.416    3.360    19.97    48.09    6.047 1532.0  11.8   3.4
22:52:22.017           5   619355.4  4838.71    8192  29.98    2.475
 0.412    3.357    21.62    45.62    6.005 1532.0  11.8   3.4
22:52:32.019           6   622502.9  4863.30    8192  29.95    2.461
 0.419    3.334    22.10    52.66    5.960 1532.3  11.8   3.4
22:52:42.018           7   620592.2  4848.38    8192  29.99    2.469
 0.416    3.347    22.76    48.33    5.966 1531.9  11.8   3.4
22:52:42.035     avg_2-7   621374.3  4854.49    8192  29.98    2.465
 0.416    3.343    25.40    52.66    5.972 1532.0  11.8   3.4

As you can see, this makes using this data really very simple for post
processing - I can just pick up the summary file, extract the "avg"
line per job and plot the results as required.

I'm yet to find in FIO if this summarization is possible. I keep
getting a lot of files which are taking a long time to post-process
into meaningful data (I need the average number of IOPs and latency
per disk/thread/run). I understand the output of FIO is not the same
as VDBench, but if I could get the combined IOPS in one file, the
latency in another and the bandwidth in a third, that would be usable.

Anyone have any pointers on how to implement this?

Many Thanks

Mark
