export interface INavItem {
  text: "string";
  onClick: (e: any) => void;
  extraStyle?: string;
}

export function NavItem({ text, onClick, extraStyle, ...rest }: INavItem) {
  return (
    <div
      onClick={onClick}
      className={`text-[15px] text-white font-extrabold cursor-pointer ${extraStyle}`}
    >
      <h4>{text}</h4>
    </div>  
  );
}
