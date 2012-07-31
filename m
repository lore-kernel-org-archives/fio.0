Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:60521 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab2GaTQC (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 31 Jul 2012 15:16:02 -0400
Message-ID: <50182EEF.8040904@kernel.dk>
Date: Tue, 31 Jul 2012 21:15:59 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Filenames on 'server' jobs to shared filesystems
References: <50058274.2070006@ed.ac.uk>
In-Reply-To: <50058274.2070006@ed.ac.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Matthew Richardson <m.richardson@ed.ac.uk>
Cc: fio@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

On 2012-07-17 17:19, Matthew Richardson wrote:
> I'm currently using fio to simulate user reads and writes to a NAS
> service, and am testing the performance of different shared filesystems
> (NFS, Samba, Glusterfs etc).
> 
> In order to properly load the box I'm using a pool of clients to connect
> to the fs (fio --server) and then launching the same job on multiple
> clients. (fio --client=a --client=b job.fio)
> 
> The resulting jobs on the different servers all seem to use the same
> file - the filename seems to be <name>.<thread>.<fileno> - in this case
> 'job.1.0':
> 
> [global]
> directory=/mnt/gluster
> rw=randrw
> size=10M
> ioengine=libaio
> 
> [job]
> 
> 
> Is there any way to have the server include some personal identifier
> (such as hostname) in the filename so that there isn't this conflict?

That's not a bad idea, to have the backend prefix with it's hostname or
similar. Let me know if you want to test (or create!) such a patch, I'd
be happy to help.

Sorry about the late response - that goes to all the emails on this
list. I've been away on business and then vacation, so it's been a while
and I'm trying to catch up.

- -- 
Jens Axboe

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBCAAGBQJQGC7rAAoJEPfTWPspceCm5cYQAMqHqMYzEMNT6xEUBUHvuRON
ZlOhAqHP191vWLDTGvbSmkDZEerd5uQULbVhWDtvdgrnfivtjv91NhQnN9D4RY7P
YNQfLXyPUHkYnc4271XqFxNnwCwQ0nNklGL3nUsGHdlHxK2nrDAsFxkMoPUkNZP+
pAS2Gpg3Enz9O0sBmeIFQpTv478RKwD8tgHEQKn/ZusRKo5XlJNBfjOJhP/oEfny
l3C7s1rhfHCsnIVL1M/AWdA+1tp8+h+byxOz49IIGa/fif0P+eCgihuU/UohDsFE
sNe2jBoXfXvW3zHYA8nUzL9vjZjLQFKgTBWldM1nuxz2SMA66O40K0BZ6x1hIOaJ
fJafWhflPNBSJBxuvwLBzGv4hsfwp0ABBCZG0uz2brLUFog3Yr+qqRJAy6yIWjmK
Ha3jaPV3sVD1cjV+xaNLdLv2QsEIAo3gghZyIFskuW+NuNkH9icgwo+i5Owl+4ER
v6c4ydcPtdJFguotOG6D4kgfl358pLfwSWTzKK3P7uve3xuAjxKdMVjgLE92/MCn
pxvOmws0hn5m3+thmodbi8ipKsHvALl+IYidWKdWAEqVz0LUGRjrZWxHxA5dX/+l
vHJjmnUvk2rI+Tzakuli9PZap7r4uieC1IfHm4gdOJKrGHztBH4yVjz9V+zsEjF/
Uwm1vfkoiwwbhkVAMxYf
=3u9j
-----END PGP SIGNATURE-----
