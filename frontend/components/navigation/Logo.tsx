import Image, { StaticImageData } from "next/image";
import logo from '../../assets/image/logo.png'

export function Logo({imagesUrl=logo}: {imagesUrl:string|StaticImageData}) {
    return ( 
        <Image src={imagesUrl} layout="responsive" />
     );
}

