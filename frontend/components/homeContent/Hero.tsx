import { Button } from "../form";
import chartImage from "../../assets/image/chart.png";
import fourCircle from "../../assets/image/fourCircle.png";
import tag from "../../assets/image/tag.png";
import Image from "next/image";
import {v4 as UUID} from 'uuid'

const buttonImages = [
  { image:chartImage, extraStyle: "justify-center bg-iris-gray " },
  { image:fourCircle, extraStyle: "justify-center bg-iris-black " },
  { image:tag, extraStyle: "justify-center bg-iris-gray " },
];
export function Hero(props: any) {
  return (
    <div className="flex justify-center items-center flex-col text-white pb-[74px] pt-[87px] ">
      <div className=" flex justify-center items-center flex-col">
        <h2 className="font-extrabold text-[45px] leading-[1.25] h-[61px]">
          Lorem ipsum
        </h2>
        <p className=" font-normal leading-[1.25] h-[40px]">
          Created by: <span className="text-iris-red whitespace-nowrap">Lorem ipsum </span>
        </p>
        <p className=" leading-[1.25] text-center h-[32px]">
          Sed ut perspiciatis unde omnis iste natus error sit voluptatem.
        </p>
        <div className="w-[592px] hidden sm:flex justify-between pt-[60px]">
          {buttonImages.map(({image, extraStyle}) => (
            <div className="w-[184px] h-[50px] " key={UUID()}>
              <Button
                text="Lorem ipsum"
                extraStyle={extraStyle}
              >
                <Image src={image} layout="responsive" />
              </Button>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}

export default Hero;
