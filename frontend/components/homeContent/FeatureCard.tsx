
interface IFeatureCard {
  mainText:string,
  subText:string,
  rating:number,
  selectCard:(e:any)=>void,
  isActive:boolean,
}


export function FeatureCard({
  mainText,
  subText,
  rating,
  selectCard,
  isActive,
}: IFeatureCard) {
  
  return (
    <div
      onClick={selectCard}
      className={`h-[100px]  py-[15px] cursor-pointer px-[24px] bg-black rounded-md   border-transparent border-[2px] ${
        isActive && "border-iris-red"
      }  `}
    >
      <div className="flex justify-center items-center flex-col">
        <p className="text-[13px] text-[#8E8B8F] whitespace-nowrap">
          {subText}
        </p>
        <h2 className="whitespace-nowrap ">{mainText}</h2>
        <p className="text-[13px] text-[#8E8B8F] whitespace-nowrap">
          {rating}%
        </p>
      </div>
    </div>
  );
}
