Return-Path: <Antonio.Jose.Rodrigues.Neto@netapp.com>
From: "Neto, Antonio Jose Rodrigues" <Antonio.Jose.Rodrigues.Neto@netapp.com>
Subject: Re: Helping to model this workload
Date: Fri, 26 Jul 2013 14:35:42 +0000
Message-ID: <CE180174.12F37%Antonio.Jose.Rodrigues.Neto@netapp.com>
In-Reply-To: <51F288DC.8000503@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <761772C89F82DA4EBC54CED6E302554B@hq.netapp.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>



On 7/26/13 10:34 AM, "Jens Axboe" <axboe@kernel.dk> wrote:

>On 07/26/2013 08:28 AM, Neto, Antonio Jose Rodrigues wrote:
>>=20
>> On 7/26/13 10:24 AM, "Jens Axboe" <axboe@kernel.dk> wrote:
>>=20
>>> On 07/26/2013 08:22 AM, Neto, Antonio Jose Rodrigues wrote:
>>>> Would be nice if we could specify?
>>>> Iodepth for sequential and random
>>>
>>> That would be easy enough to add.
>>>
>>>> Numjobs for sequential and random (for example: I would like to have
>>>>16
>>>> jobs doing random and 1 job only doing sequential)
>>>
>>> That's pretty easy to do manually by just having the two sections in
>>>the
>>> job file.
>>>
>>> --=20
>>> Jens Axboe
>>>
>>> --
>>=20
>> Something like this? Do you have an example? I am confused with 2
>>sections
>> and the percentage of the distribution of sequential and random plus the
>> difference of block size
>
>For multiple sections, you put the shared items in a [global] section.
>That section applies to any job in the file. That also gives you a
>better overview of the shared and distinct properties of each job.
>
>--=20
>Jens Axboe
>
>--
>To unsubscribe from this list: send the line "unsubscribe fio" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

Let me try


