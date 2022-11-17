import Image from "next/image";

export function Button({ children, text, extraStyle }: any) {
  return (
    <div
      className={`flex h-full w-full  cursor-pointer items-center rounded-md hover:border-b-iris-red border-transparent border-[2px]  ${extraStyle}`}
    >
      {children && (
        <div className=" transform -translate-y-[1px] w-[17px] h-[16px] mr-[9px]  ">
          {children}
        </div>
      )}
      <button className=" whitespace-nowrap ">{text}</button>
    </div>
  );
}
