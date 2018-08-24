Return-Path: <axboe@kernel.dk>
Subject: Re: Zoned block device support for fio
References: <a1373211271aee157884ec6dea024ecc2c17331d.camel@wdc.com>
 <be10a7d0-2d90-9381-4d05-6c4c4b81d461@kernel.dk>
 <480f2de2cfe43c779304f7b470f84ed3f9903713.camel@wdc.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <052e5a14-5e9a-c68b-bd34-3e14c50daa67@kernel.dk>
Date: Fri, 24 Aug 2018 10:46:08 -0600
MIME-Version: 1.0
In-Reply-To: <480f2de2cfe43c779304f7b470f84ed3f9903713.camel@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jason Jorgensen <jason.jorgensen@wdc.com>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, "phillip.a.chen@seagate.com" <phillip.a.chen@seagate.com>, Damien Le Moal <Damien.LeMoal@wdc.com>, Masato Suzuki <masato.suzuki@wdc.com>, Matias Bjorling <Matias.Bjorling@wdc.com>
List-ID: <fio@vger.kernel.org>

On 8/24/18 10:42 AM, Bart Van Assche wrote:
>> zbd_init() should not be something that
>> is unconditionally called. Only do it if ZONE_MODE_ZBD is set and make
>> that explicit.
> 
> There is a test in the zbd_init() code that makes fio report an error
> message if --zonemode=zbd has not been specified for zoned block devices:
> 
> 	if (td->o.zone_mode != ZONE_MODE_ZBD) {
>  		for_each_file(td, f, i) {
> 			if (get_zbd_model(f->file_name) != ZBD_DM_HOST_MANAGED)
> 				continue;
> 			log_err("%s: Using --zonemode=zbd is mandatory for host-managed drives\n\n",
> 				f->file_name);
> 			return 1;
> 		}
> 	}
> 
> I think that error message is very helpful for people who run fio for the
> first time against a zoned block device so I would like to keep that error
> message. However, I'm not sure where you would like me to move that code if
> zbd_init() is only called for --zonemode=zbd?

That's exactly what I'm objecting to. If someone doesn't ask for zoned
behavior, don't do any of that. If the test then fails, then the test
will fail. Don't look or parse any of that stuff. If need be, you could
introduce an error check similarly to how we add an extra information
note if the first O_DIRECT IO fails, for instance.

-- 
Jens Axboe


