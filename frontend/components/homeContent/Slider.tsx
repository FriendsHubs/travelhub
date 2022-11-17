import {v4 as UUID} from 'uuid'
import Image from "next/image";

interface ISlider {
  images:string[]
  children?:React.ReactNode
}

export function Slider({images,children}: ISlider) {
  return (
    <div className="flex justify-center  ">
      <div className="w-full  relative">
        <div className="absolute inset-0 flex justify-center">
          <div className="transform translate-y-[176px] z-10 w-[149px] h-[149px]">
            {children }
          </div>
        </div>
        <div className="flex w-full overflow-x-auto container-snap">
          <div className="flex">
            {images.map(image=>(<div className="md:w-[349px] sm:w-[249px] w-[149px] h-full cursor-pointer  " key={UUID()}>
            <Image
                height={265}
                width={349}
                src={image}
              />
            </div>))}
          </div>
        </div>
      </div>
    </div>
  );
}
