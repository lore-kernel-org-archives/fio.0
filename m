Message-ID: <53F3B08C.30703@kernel.dk>
Date: Tue, 19 Aug 2014 15:16:12 -0500
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] Add unlink hook to ioengine API, gluster ioengine
References: <1408465733-3061-1-git-send-email-castor.fu@egocast.org>
In-Reply-To: <1408465733-3061-1-git-send-email-castor.fu@egocast.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: castor.fu@egocast.org, fio@vger.kernel.org
Cc: Castor Fu <castor@alumni.caltech.edu>, Huamin Chen <hchen@redhat.com>
List-ID: <fio@vger.kernel.org>

On 2014-08-19 11:28, castor.fu@egocast.org wrote:
> From: Castor Fu <castor@alumni.caltech.edu>
>
> fio would just call unlink even with engines that are not using the
> operating systems file namespace... This provides a hook to allow
> overriding that, with a default handler, and implements it for the
> gluster ioengine.
>
> There are others which it'd probably make sense I'm sure.
>
> Huamin Chen looked over my changes to the gluster code earlier...
>> I like this unlink idea, it would be great if you can also make unlink optional (if my coding reading is correct). This looks a great pull request candidate to fio. Please ping Axboe after you are done. He is not actively watching pull requests.
>
>> Please also feel free to augment gluster code and pull me for review if necessary.
>

Thanks, applied. I do monitor pull requests, I setup github to notify me 
of them when this last came up. But either is fine, pull request of 
emailed patch.

-- 
Jens Axboe


