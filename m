Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH 2/2] init: force threads when checking overlap in offload
 mode
References: <20181016152650.7784-1-vincentfu@gmail.com>
 <20181016152650.7784-3-vincentfu@gmail.com>
 <1a792daa-4327-1a4e-48df-4c691630c834@kernel.dk>
 <BYAPR04MB44214E35A13DF6609204B4D695FE0@BYAPR04MB4421.namprd04.prod.outlook.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <cea897b5-1264-e8a0-7279-e03a12545b77@kernel.dk>
Date: Tue, 16 Oct 2018 09:41:08 -0600
MIME-Version: 1.0
In-Reply-To: <BYAPR04MB44214E35A13DF6609204B4D695FE0@BYAPR04MB4421.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Vincent Fu <Vincent.Fu@wdc.com>, "vincentfu@gmail.com" <vincentfu@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 10/16/18 9:33 AM, Vincent Fu wrote:
> On 10/16/2018 11:29 AM, Jens Axboe wrote:
>> On 10/16/18 9:26 AM, vincentfu@gmail.com wrote:
>>> From: Vincent Fu <vincent.fu@wdc.com>
>>>
>>> serialize_overlap combined with io_submit_mode=offload requires
>>> threads. Print a warning and force the use of threads if the user
>>> did not specify threads.
>> Why does it require threads? Is it because of the use of a pthread
>> mutex? If so, that should just be a fio mutex instead, and you would
>> not have this restrictions (on most platforms, at least).
>>
> It requires threads because io_u's are not allocated from the shared
> memory area. Jobs need to access each other's io_u's to check for overlap.

Gotcha. Might be better to change that rather than impose limitations
on needing threads for this specific configuration.

Probably make it dependent on offload and serialize_overlap for now,
it'd be less risky. The risk here being that higher queue depth
jobs running out of memory in the smalloc pool.

-- 
Jens Axboe


