Return-Path: <Antonio.Jose.Rodrigues.Neto@netapp.com>
From: "Neto, Antonio Jose Rodrigues" <Antonio.Jose.Rodrigues.Neto@netapp.com>
Subject: Re: Helping to model this workload
Date: Fri, 26 Jul 2013 14:39:20 +0000
Message-ID: <CE1801F9.12F3C%Antonio.Jose.Rodrigues.Neto@netapp.com>
In-Reply-To: <CE180174.12F37%Antonio.Jose.Rodrigues.Neto@netapp.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F7DE713AA3411C42B9B36B98637DABD6@hq.netapp.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

>>>>>
>>>>>Would be nice if we could specify?
>>>>> Iodepth for sequential and random
>>>>
>>>> That would be easy enough to add.
>>>>
>>>>> Numjobs for sequential and random (for example: I would like to have
>>>>>16
>>>>> jobs doing random and 1 job only doing sequential)
>>>>
>>>> That's pretty easy to do manually by just having the two sections in
>>>>the
>>>> job file.
>>>>
>>>> --=20
>>>> Jens Axboe
>>>>
>>>> --
>>>=20
>>> Something like this? Do you have an example? I am confused with 2
>>>sections
>>> and the percentage of the distribution of sequential and random plus
>>>the
>>> difference of block size
>>
>>For multiple sections, you put the shared items in a [global] section.
>>That section applies to any job in the file. That also gives you a
>>better overview of the shared and distinct properties of each job.
>>
>>--=20
>>Jens Axboe
>>
>>--
>>To unsubscribe from this list: send the line "unsubscribe fio" in
>>the body of a message to majordomo@vger.kernel.org
>>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>Let me try
>


This one? How about the reporting? I would love to have a unified
reporting by section like:

Random XYZ IOPS and x latency
Sequential ABC IOPS and y latency


[global]
bs=3D64k,4k
bs_is_seq_rand=3D1
ioengine=3Dlibaio
direct=3D1
runtime=3D2400
size=3D2000g
filename=3D\\.\PhysicalDrive9:\\.\PhysicalDrive10
rw=3Drandrw
rwmixread=3D85
percentage_random=3D59,67
thread
unified_rw_reporting=3D1
group_reporting=3D1

[random]
iodepth=3D2
numjobs=3D64

[sequential]
iodepth=3D1
numjobs=3D1


